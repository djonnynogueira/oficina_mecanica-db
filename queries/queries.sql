-- =============================================
-- QUERIES - OFICINA MECÂNICA
-- =============================================

-- =============================================
-- QUERY 1: Quantos serviços cada cliente solicitou?
-- (SELECT, JOIN, GROUP BY, ORDER BY, atributo derivado)
-- =============================================
SELECT 
    c.idCustomer,
    c.Nome AS Cliente,
    c.CPF,
    COUNT(s.idService) AS TotalServicos,
    COUNT(DISTINCT v.idVehicle_OS) AS TotalVeiculos,
    SUM(s.Value) AS ValorTotalServicos,
    AVG(s.Value) AS TicketMedio,
    CASE 
        WHEN COUNT(s.idService) = 0 THEN 'Sem Serviços'
        WHEN COUNT(s.idService) <= 2 THEN 'Cliente Novo'
        WHEN COUNT(s.idService) <= 5 THEN 'Cliente Regular'
        ELSE 'Cliente VIP'
    END AS CategoriaCliente
FROM Customer c
LEFT JOIN Service s ON c.idCustomer = s.Customer_idCustomer
LEFT JOIN Vehicle_OS v ON c.idCustomer = v.Customer_idCustomer
GROUP BY c.idCustomer, c.Nome, c.CPF
ORDER BY TotalServicos DESC, ValorTotalServicos DESC;

-- =============================================
-- QUERY 2: Serviços por status com detalhes
-- (WHERE, GROUP BY, HAVING, ORDER BY)
-- =============================================
SELECT 
    s.Status,
    COUNT(*) AS QuantidadeServicos,
    SUM(s.Value) AS ValorTotal,
    AVG(s.Value) AS ValorMedio,
    MIN(s.Value) AS MenorValor,
    MAX(s.Value) AS MaiorValor,
    COUNT(DISTINCT s.Customer_idCustomer) AS ClientesUnicos
FROM Service s
WHERE s.Status != 'Cancelado'
GROUP BY s.Status
HAVING QuantidadeServicos > 0
ORDER BY 
    FIELD(s.Status, 'Aguardando', 'Em Andamento', 'Concluído'),
    ValorTotal DESC;

-- =============================================
-- QUERY 3: Ordens de Serviço com detalhes completos
-- (JOIN múltiplo, atributos derivados, CASE)
-- =============================================
SELECT 
    os.NumeroOS,
    os.Description AS DescricaoOS,
    os.Status AS StatusOS,
    os.DataEmissao,
    os.DataConclusao,
    DATEDIFF(COALESCE(os.DataConclusao, NOW()), os.DataEmissao) AS DiasDecorridos,
    c.Nome AS Cliente,
    c.CPF,
    c.Contact AS Telefone,
    GROUP_CONCAT(DISTINCT s.Service_Type ORDER BY s.Service_Type SEPARATOR ', ') AS TiposServico,
    COUNT(DISTINCT oss.Service_idService) AS QuantidadeServicos,
    os.ValorTotal,
    SUM(osp.ValorTotal) AS ValorPecas,
    os.ValorTotal + COALESCE(SUM(osp.ValorTotal), 0) AS ValorTotalComPecas,
    CASE 
        WHEN os.Status = 'Concluída' THEN 'Finalizada'
        WHEN DATEDIFF(NOW(), os.DataEmissao) > 7 THEN 'Atrasada'
        WHEN DATEDIFF(NOW(), os.DataEmissao) > 3 THEN 'Atenção'
        ELSE 'No Prazo'
    END AS SituacaoPrazo
FROM OS os
INNER JOIN OS_Service oss ON os.idOS = oss.OS_idOS
INNER JOIN Service s ON oss.Service_idService = s.idService
INNER JOIN Customer c ON s.Customer_idCustomer = c.idCustomer
LEFT JOIN OS_Pecas osp ON os.idOS = osp.OS_idOS
GROUP BY os.idOS, os.NumeroOS, os.Description, os.Status, os.DataEmissao, 
         os.DataConclusao, os.ValorTotal, c.Nome, c.CPF, c.Contact
ORDER BY os.DataEmissao DESC;

-- =============================================
-- QUERY 4: Tipos de serviço mais solicitados
-- (GROUP BY, HAVING, ORDER BY, atributos derivados)
-- =============================================
SELECT 
    s.Service_Type AS TipoServico,
    COUNT(*) AS QuantidadeSolicitacoes,
    SUM(s.Value) AS ReceitaTotal,
    AVG(s.Value) AS ValorMedio,
    MIN(s.Value) AS MenorValor,
    MAX(s.Value) AS MaiorValor,
    COUNT(DISTINCT s.Customer_idCustomer) AS ClientesAtendidos,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Service), 2) AS PercentualTotal
FROM Service s
GROUP BY s.Service_Type
HAVING QuantidadeSolicitacoes > 0
ORDER BY QuantidadeSolicitacoes DESC, ReceitaTotal DESC;

-- =============================================
-- QUERY 5: Veículos e seus históricos de serviços
-- (JOIN múltiplo, GROUP BY, ORDER BY)
-- =============================================
SELECT 
    v.idVehicle_OS,
    v.Model AS Modelo,
    v.License AS Placa,
    v.Year AS Ano,
    v.Vehicle_condition AS Condicao,
    c.Nome AS Proprietario,
    c.Contact AS Telefone,
    COUNT(s.idService) AS TotalServicos,
    SUM(s.Value) AS ValorTotalGasto,
    MAX(s.DataCriacao) AS UltimoServico,
    DATEDIFF(NOW(), MAX(s.DataCriacao)) AS DiasDesdeUltimoServico,
    GROUP_CONCAT(
        DISTINCT s.Service_Type 
        ORDER BY s.DataCriacao DESC 
        SEPARATOR ' | '
    ) AS HistoricoServicos
FROM Vehicle_OS v
INNER JOIN Customer c ON v.Customer_idCustomer = c.idCustomer
LEFT JOIN Service s ON c.idCustomer = s.Customer_idCustomer
GROUP BY v.idVehicle_OS, v.Model, v.License, v.Year, v.Vehicle_condition, 
         c.Nome, c.Contact
ORDER BY TotalServicos DESC, ValorTotalGasto DESC;

-- =============================================
-- QUERY 6: Mecânicos e produtividade
-- (JOIN, GROUP BY, atributos derivados)
-- =============================================
SELECT 
    mt.idMechannic_team,
    mt.Nome AS Mecanico,
    mt.Mec_specialty AS Especialidade,
    COUNT(DISTINCT sm.Service_idService) AS ServicosRealizados,
    SUM(sm.HorasTrabalhadas) AS TotalHorasTrabalhadas,
    AVG(sm.HorasTrabalhadas) AS MediaHorasPorServico,
    COUNT(DISTINCT DATE(sm.DataInicio)) AS DiasTrabalhadosTotal,
    ROUND(SUM(sm.HorasTrabalhadas) / NULLIF(COUNT(DISTINCT DATE(sm.DataInicio)), 0), 2) AS MediaHorasPorDia,
    SUM(CASE WHEN sm.DataConclusao IS NOT NULL THEN 1 ELSE 0 END) AS ServicosConcluidos,
    SUM(CASE WHEN sm.DataConclusao IS NULL THEN 1 ELSE 0 END) AS ServicosEmAndamento
FROM Mechanic_team mt
LEFT JOIN Service_Mechanic sm ON mt.idMechannic_team = sm.Mechanic_team_idMechannic_team
GROUP BY mt.idMechannic_team, mt.Nome, mt.Mec_specialty
ORDER BY ServicosRealizados DESC, TotalHorasTrabalhadas DESC;

-- =============================================
-- QUERY 7: Análise de pagamentos
-- (JOIN, GROUP BY, CASE, atributos derivados)
-- =============================================
SELECT 
    p.Pay_method AS FormaPagamento,
    COUNT(*) AS QuantidadePagamentos,
    SUM(p.ValorPago) AS ValorTotal,
    AVG(p.ValorPago) AS TicketMedio,
    MIN(p.ValorPago) AS MenorValor,
    MAX(p.ValorPago) AS MaiorValor,
    SUM(CASE WHEN p.StatusPagamento = 'Aprovado' THEN 1 ELSE 0 END) AS PagamentosAprovados,
    SUM(CASE WHEN p.StatusPagamento = 'Pendente' THEN 1 ELSE 0 END) AS PagamentosPendentes,
    SUM(CASE WHEN p.StatusPagamento = 'Recusado' THEN 1 ELSE 0 END) AS PagamentosRecusados,
    ROUND(
        SUM(CASE WHEN p.StatusPagamento = 'Aprovado' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS TaxaAprovacao
FROM Payment p
GROUP BY p.Pay_method
ORDER BY ValorTotal DESC;

-- =============================================
-- QUERY 8: Clientes com pagamentos pendentes
-- (WHERE, JOIN, ORDER BY)
-- =============================================
SELECT 
    c.idCustomer,
    c.Nome AS Cliente,
    c.CPF,
    c.Contact AS Telefone,
    os.NumeroOS,
    os.Description AS DescricaoOS,
    p.Pay_method AS FormaPagamento,
    p.ValorPago,
    p.DataPagamento,
    DATEDIFF(NOW(), p.DataPagamento) AS DiasEmAberto
FROM Customer c
INNER JOIN Payment p ON c.idCustomer = p.Customer_idCustomer
INNER JOIN OS os ON p.OS_idOS = os.idOS
WHERE p.StatusPagamento = 'Pendente'
ORDER BY DiasEmAberto DESC, p.ValorPago DESC;

-- =============================================
-- QUERY 9: Peças mais utilizadas
-- (JOIN, GROUP BY, ORDER BY)
-- =============================================
SELECT 
    pc.idPeca,
    pc.Nome AS Peca,
    pc.Descricao,
    pc.ValorUnitario,
    pc.QuantidadeEstoque,
    pc.Fornecedor,
    COUNT(osp.idOS_Pecas) AS QuantidadeVezesUtilizada,
    SUM(osp.Quantidade) AS QuantidadeTotalUtilizada,
    SUM(osp.ValorTotal) AS ReceitaTotal,
    CASE 
        WHEN pc.QuantidadeEstoque = 0 THEN 'SEM ESTOQUE - URGENTE'
        WHEN pc.QuantidadeEstoque < 10 THEN 'ESTOQUE BAIXO'
        WHEN pc.QuantidadeEstoque < 20 THEN 'ESTOQUE MODERADO'
        ELSE 'ESTOQUE OK'
    END AS StatusEstoque
FROM Pecas pc
LEFT JOIN OS_Pecas osp ON pc.idPeca = osp.Pecas_idPeca
GROUP BY pc.idPeca, pc.Nome, pc.Descricao, pc.ValorUnitario, 
         pc.QuantidadeEstoque, pc.Fornecedor
ORDER BY QuantidadeVezesUtilizada DESC, ReceitaTotal DESC;

-- =============================================
-- QUERY 10: Receita mensal (simulação)
-- (GROUP BY, atributos derivados, ORDER BY)
-- =============================================
SELECT 
    DATE_FORMAT(p.DataPagamento, '%Y-%m') AS MesAno,
    MONTHNAME(p.DataPagamento) AS Mes,
    YEAR(p.DataPagamento) AS Ano,
    COUNT(DISTINCT p.OS_idOS) AS QuantidadeOS,
    COUNT(DISTINCT p.Customer_idCustomer) AS ClientesAtendidos,
    COUNT(*) AS TotalPagamentos,
    SUM(p.ValorPago) AS ReceitaTotal,
    AVG(p.ValorPago) AS TicketMedio,
    SUM(CASE WHEN p.StatusPagamento = 'Aprovado' THEN p.ValorPago ELSE 0 END) AS ReceitaConfirmada,
    SUM(CASE WHEN p.StatusPagamento = 'Pendente' THEN p.ValorPago ELSE 0 END) AS ReceitaPendente
FROM Payment p
GROUP BY MesAno, Mes, Ano
ORDER BY MesAno DESC;

-- =============================================
-- QUERY 11: OS com maior valor (TOP 10)
-- (JOIN, ORDER BY, LIMIT)
-- =============================================
SELECT 
    os.NumeroOS,
    os.Description,
    c.Nome AS Cliente,
    os.Status,
    os.ValorTotal AS ValorServicos,
    COALESCE(SUM(osp.ValorTotal), 0) AS ValorPecas,
    os.ValorTotal + COALESCE(SUM(osp.ValorTotal), 0) AS ValorTotalFinal,
    os.DataEmissao,
    os.DataConclusao
FROM OS os
INNER JOIN OS_Service oss ON os.idOS = oss.OS_idOS
INNER JOIN Service s ON oss.Service_idService = s.idService
INNER JOIN Customer c ON s.Customer_idCustomer = c.idCustomer
LEFT JOIN OS_Pecas osp ON os.idOS = osp.OS_idOS
GROUP BY os.idOS, os.NumeroOS, os.Description, c.Nome, os.Status, 
         os.ValorTotal, os.DataEmissao, os.DataConclusao
ORDER BY ValorTotalFinal DESC
LIMIT 10;

-- =============================================
-- QUERY 12: Serviços atrasados
-- (WHERE, JOIN, atributos derivados, ORDER BY)
-- =============================================
SELECT 
    s.idService,
    s.Service_Type AS TipoServico,
    s.Description AS Descricao,
    c.Nome AS Cliente,
    c.Contact AS Telefone,
    s.Deadline AS Prazo,
    s.Status,
    DATEDIFF(NOW(), s.Deadline) AS DiasAtraso,
    s.Value AS Valor,
    CASE 
        WHEN DATEDIFF(NOW(), s.Deadline) > 10 THEN 'CRÍTICO'
        WHEN DATEDIFF(NOW(), s.Deadline) > 5 THEN 'URGENTE'
        ELSE 'ATENÇÃO'
    END AS Prioridade
FROM Service s
INNER JOIN Customer c ON s.Customer_idCustomer = c.idCustomer
WHERE s.Deadline < CURDATE()
  AND s.Status NOT IN ('Concluído', 'Cancelado')
ORDER BY DiasAtraso DESC;

-- =============================================
-- QUERY 13: Especialidades dos mecânicos e demanda
-- (GROUP BY, ORDER BY)
-- =============================================
SELECT 
    mt.Mec_specialty AS Especialidade,
    COUNT(DISTINCT mt.idMechannic_team) AS QuantidadeMecanicos,
    COUNT(sm.idService_Mechanic) AS ServicosRealizados,
    SUM(sm.HorasTrabalhadas) AS TotalHoras,
    AVG(sm.HorasTrabalhadas) AS MediaHorasPorServico,
    ROUND(
        COUNT(sm.idService_Mechanic) / NULLIF(COUNT(DISTINCT mt.idMechannic_team), 0), 
        2
    ) AS MediaServicosPorMecanico
FROM Mechanic_team mt
LEFT JOIN Service_Mechanic sm ON mt.idMechannic_team = sm.Mechanic_team_idMechannic_team
GROUP BY mt.Mec_specialty
ORDER BY ServicosRealizados DESC;

-- =============================================
-- QUERY 14: Clientes inativos (sem serviços recentes)
-- (LEFT JOIN, WHERE, atributos derivados)
-- =============================================
SELECT 
    c.idCustomer,
    c.Nome AS Cliente,
    c.CPF,
    c.Contact AS Telefone,
    c.Address AS Endereco,
    COUNT(v.idVehicle_OS) AS QuantidadeVeiculos,
    MAX(s.DataCriacao) AS UltimoServico,
    DATEDIFF(NOW(), MAX(s.DataCriacao)) AS DiasDesdeUltimoServico,
    CASE 
        WHEN MAX(s.DataCriacao) IS NULL THEN 'Nunca utilizou serviços'
        WHEN DATEDIFF(NOW(), MAX(s.DataCriacao)) > 365 THEN 'Inativo há mais de 1 ano'
        WHEN DATEDIFF(NOW(), MAX(s.DataCriacao)) > 180 THEN 'Inativo há mais de 6 meses'
        ELSE 'Inativo há mais de 3 meses'
    END AS StatusInatividade
FROM Customer c
LEFT JOIN Vehicle_OS v ON c.idCustomer = v.Customer_idCustomer
LEFT JOIN Service s ON c.idCustomer = s.Customer_idCustomer
GROUP BY c.idCustomer, c.Nome, c.CPF, c.Contact, c.Address
HAVING UltimoServico IS NULL 
    OR DATEDIFF(NOW(), MAX(s.DataCriacao)) > 90
ORDER BY DiasDesdeUltimoServico DESC;

-- =============================================
-- QUERY 15: Dashboard Executivo
-- (UNION ALL, agregações)
-- =============================================
SELECT 
    'Clientes Cadastrados' AS Metrica,
    COUNT(*) AS Total,
    NULL AS Detalhes
FROM Customer

UNION ALL

SELECT 
    'Veículos Cadastrados' AS Metrica,
    COUNT(*) AS Total,
    NULL AS Detalhes
FROM Vehicle_OS

UNION ALL

SELECT 
    'Serviços Solicitados' AS Metrica,
    COUNT(*) AS Total,
    CONCAT('Concluídos: ', SUM(CASE WHEN Status = 'Concluído' THEN 1 ELSE 0 END)) AS Detalhes
FROM Service

UNION ALL

SELECT 
    'Ordens de Serviço' AS Metrica,
    COUNT(*) AS Total,
    CONCAT('Abertas: ', SUM(CASE WHEN Status IN ('Aberta', 'Em Execução') THEN 1 ELSE 0 END)) AS Detalhes
FROM OS

UNION ALL

SELECT 
    'Receita Total' AS Metrica,
    ROUND(SUM(ValorPago), 2) AS Total,
    CONCAT('Aprovada: R$ ', ROUND(SUM(CASE WHEN StatusPagamento = 'Aprovado' THEN ValorPago ELSE 0 END), 2)) AS Detalhes
FROM Payment

UNION ALL

SELECT 
    'Mecânicos Ativos' AS Metrica,
    COUNT(*) AS Total,
    NULL AS Detalhes
FROM Mechanic_team

UNION ALL

SELECT 
    'Peças em Estoque' AS Metrica,
    SUM(QuantidadeEstoque) AS Total,
    CONCAT('Valor: R$ ', ROUND(SUM(ValorUnitario * QuantidadeEstoque), 2)) AS Detalhes
FROM Pecas;
