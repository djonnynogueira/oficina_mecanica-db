-- =============================================
-- INSERÇÃO DE DADOS DE TESTE
-- Sistema de Oficina Mecânica
-- =============================================

-- Inserindo Clientes
INSERT INTO Customer (Nome, CPF, Contact, Address) VALUES
('João Silva Santos', '12345678901', '(11) 98765-4321', 'Rua das Flores, 123, São Paulo - SP'),
('Maria Oliveira Costa', '98765432109', '(11) 97654-3210', 'Av. Paulista, 1000, São Paulo - SP'),
('Pedro Henrique Souza', '45678912345', '(21) 99876-5432', 'Rua do Comércio, 456, Rio de Janeiro - RJ'),
('Ana Paula Ferreira', '78945612378', '(31) 98765-1234', 'Av. Afonso Pena, 789, Belo Horizonte - MG'),
('Carlos Eduardo Lima', '32165498732', '(41) 97654-8765', 'Rua XV de Novembro, 321, Curitiba - PR'),
('Juliana Martins Rocha', '65498732165', '(51) 96543-2109', 'Av. Ipiranga, 654, Porto Alegre - RS'),
('Roberto Carlos Alves', '14725836914', '(85) 95432-1098', 'Rua Barão de Studart, 147, Fortaleza - CE'),
('Fernanda Cristina Dias', '85296374185', '(71) 94321-0987', 'Av. Sete de Setembro, 852, Salvador - BA');

-- Inserindo Veículos
INSERT INTO Vehicle_OS (Customer_idCustomer, Model, License, Year, Vehicle_condition) VALUES
(1, 'Fiat Uno Vivace 1.0', 'ABC-1234', 2018, 'Bom estado geral, pequenos riscos na lataria'),
(1, 'Honda Civic EXL 2.0', 'XYZ-5678', 2020, 'Excelente estado'),
(2, 'Volkswagen Gol 1.6', 'DEF-9012', 2015, 'Desgaste normal, precisa revisão'),
(3, 'Chevrolet Onix LT 1.4', 'GHI-3456', 2019, 'Bom estado, bateria fraca'),
(4, 'Toyota Corolla XEi 2.0', 'JKL-7890', 2021, 'Excelente estado, apenas revisão preventiva'),
(5, 'Ford Ka SE 1.0', 'MNO-2345', 2017, 'Estado regular, problemas no ar condicionado'),
(6, 'Hyundai HB20 1.6', 'PQR-6789', 2016, 'Bom estado, suspensão barulhenta'),
(7, 'Renault Sandero 1.6', 'STU-0123', 2014, 'Estado regular, precisa funilaria'),
(8, 'Nissan Versa SL 1.6', 'VWX-4567', 2022, 'Excelente estado, zero km'),
(2, 'Fiat Palio Weekend 1.4', 'YZA-8901', 2013, 'Estado regular, motor falhando');

-- Inserindo Serviços
INSERT INTO Service (Customer_idCustomer, Service_Type, Description, Deadline, Value, Status) VALUES
(1, 'Revisão', 'Revisão dos 20.000 km', '2025-11-15', 450.00, 'Em Andamento'),
(1, 'Troca de Óleo', 'Troca de óleo e filtros', '2025-11-10', 250.00, 'Concluído'),
(2, 'Manutenção Preventiva', 'Revisão geral preventiva', '2025-11-20', 800.00, 'Aguardando'),
(3, 'Freios', 'Troca de pastilhas e discos de freio', '2025-11-12', 650.00, 'Em Andamento'),
(4, 'Alinhamento', 'Alinhamento e balanceamento', '2025-11-08', 180.00, 'Concluído'),
(5, 'Ar Condicionado', 'Recarga de gás e limpeza do sistema', '2025-11-18', 350.00, 'Aguardando'),
(6, 'Suspensão', 'Troca de amortecedores dianteiros', '2025-11-25', 900.00, 'Aguardando'),
(7, 'Funilaria', 'Reparo de amassados na porta traseira', '2025-11-30', 1200.00, 'Aguardando'),
(8, 'Revisão', 'Primeira revisão 1.000 km', '2025-11-05', 0.00, 'Concluído'),
(2, 'Motor', 'Diagnóstico e reparo de falhas no motor', '2025-12-05', 1500.00, 'Em Andamento'),
(3, 'Elétrica', 'Troca de bateria e verificação elétrica', '2025-11-14', 450.00, 'Em Andamento'),
(4, 'Pintura', 'Pintura completa do veículo', '2025-12-10', 3500.00, 'Aguardando');

-- Inserindo Ordens de Serviço
INSERT INTO OS (NumeroOS, Description, Status, ValorTotal, DataConclusao) VALUES
('OS-2025-001', 'Revisão e troca de óleo - Fiat Uno', 'Concluída', 700.00, '2025-11-03 16:30:00'),
('OS-2025-002', 'Manutenção de freios - Chevrolet Onix', 'Em Execução', 650.00, NULL),
('OS-2025-003', 'Alinhamento - Toyota Corolla', 'Concluída', 180.00, '2025-11-02 14:00:00'),
('OS-2025-004', 'Primeira revisão - Nissan Versa', 'Concluída', 0.00, '2025-11-01 10:00:00'),
('OS-2025-005', 'Reparo motor - Fiat Palio', 'Em Execução', 1500.00, NULL),
('OS-2025-006', 'Troca de bateria - Chevrolet Onix', 'Em Execução', 450.00, NULL),
('OS-2025-007', 'Manutenção preventiva - Volkswagen Gol', 'Aberta', 800.00, NULL),
('OS-2025-008', 'Ar condicionado - Ford Ka', 'Aberta', 350.00, NULL),
('OS-2025-009', 'Suspensão - Hyundai HB20', 'Aberta', 900.00, NULL),
('OS-2025-010', 'Funilaria - Renault Sandero', 'Aberta', 1200.00, NULL);

-- Relacionando OS com Services
INSERT INTO OS_Service (OS_idOS, Service_idService, QuantidadeHoras, ValorServico) VALUES
(1, 1, 3.5, 450.00),
(1, 2, 1.0, 250.00),
(2, 4, 4.0, 650.00),
(3, 5, 1.5, 180.00),
(4, 9, 0.5, 0.00),
(5, 10, 8.0, 1500.00),
(6, 11, 2.0, 450.00),
(7, 3, 5.0, 800.00),
(8, 6, 3.0, 350.00),
(9, 7, 6.0, 900.00),
(10, 8, 10.0, 1200.00);

-- Inserindo Equipes de Mecânicos
INSERT INTO Mechanic_team (Nome, Mec_specialty, Address, Telefone) VALUES
('José Carlos Mecânico', 'Motor e Transmissão', 'Oficina Central', '(11) 3456-7890'),
('Antônio Silva', 'Suspensão e Freios', 'Oficina Central', '(11) 3456-7891'),
('Paulo Roberto', 'Elétrica Automotiva', 'Oficina Central', '(11) 3456-7892'),
('Marcos Vinícius', 'Ar Condicionado', 'Oficina Central', '(11) 3456-7893'),
('Ricardo Alves', 'Funilaria e Pintura', 'Setor de Funilaria', '(11) 3456-7894'),
('Fernando Costa', 'Alinhamento e Balanceamento', 'Setor de Alinhamento', '(11) 3456-7895'),
('Luiz Henrique', 'Revisão Geral', 'Oficina Central', '(11) 3456-7896');

-- Relacionando Serviços com Mecânicos
INSERT INTO Service_Mechanic (Service_idService, Mechanic_team_idMechannic_team, DataInicio, DataConclusao, HorasTrabalhadas) VALUES
(1, 7, '2025-11-01 08:00:00', '2025-11-03 16:00:00', 3.5),
(2, 7, '2025-11-01 08:00:00', '2025-11-01 10:00:00', 1.0),
(4, 2, '2025-11-05 09:00:00', NULL, 2.5),
(5, 6, '2025-11-02 13:00:00', '2025-11-02 15:00:00', 1.5),
(9, 7, '2025-10-31 10:00:00', '2025-10-31 11:00:00', 0.5),
(10, 1, '2025-11-04 08:00:00', NULL, 5.0),
(11, 3, '2025-11-06 09:00:00', NULL, 1.5);

-- Inserindo Peças
INSERT INTO Pecas (Nome, Descricao, ValorUnitario, QuantidadeEstoque, Fornecedor) VALUES
('Óleo Motor 5W30', 'Óleo sintético para motor', 45.00, 50, 'Petrobrás'),
('Filtro de Óleo', 'Filtro de óleo padrão', 25.00, 80, 'Mann Filter'),
('Filtro de Ar', 'Filtro de ar motor', 35.00, 60, 'Tecfil'),
('Pastilha de Freio Dianteira', 'Jogo de pastilhas', 120.00, 40, 'Fras-le'),
('Disco de Freio', 'Par de discos ventilados', 280.00, 25, 'Fremax'),
('Bateria 60Ah', 'Bateria automotiva 60 amperes', 380.00, 15, 'Moura'),
('Amortecedor Dianteiro', 'Amortecedor original', 320.00, 20, 'Cofap'),
('Gás R134a', 'Gás para ar condicionado', 85.00, 30, 'DuPont'),
('Vela de Ignição', 'Jogo com 4 velas', 95.00, 45, 'NGK'),
('Correia Dentada', 'Kit correia dentada com tensor', 250.00, 18, 'Gates');

-- Relacionando Peças com OS
INSERT INTO OS_Pecas (OS_idOS, Pecas_idPeca, Quantidade, ValorUnitario) VALUES
(1, 1, 4, 45.00),
(1, 2, 1, 25.00),
(1, 3, 1, 35.00),
(2, 4, 1, 120.00),
(2, 5, 2, 280.00),
(3, 9, 1, 95.00),
(5, 9, 1, 95.00),
(5, 10, 1, 250.00),
(6, 6, 1, 380.00);

-- Inserindo Pagamentos
INSERT INTO Payment (OS_idOS, Service_idService, Customer_idCustomer, Pay_method, ValorPago, StatusPagamento) VALUES
(1, 1, 1, 'Cartão Crédito', 400.00, 'Aprovado'),
(1, 2, 1, 'PIX', 300.00, 'Aprovado'),
(2, 4, 3, 'Cartão Débito', 650.00, 'Pendente'),
(3, 5, 4, 'PIX', 180.00, 'Aprovado'),
(4, 9, 8, 'Dinheiro', 0.00, 'Aprovado'),
(5, 10, 2, 'Cartão Crédito', 800.00, 'Aprovado'),
(5, 10, 2, 'Boleto', 700.00, 'Pendente'),
(6, 11, 3, 'PIX', 450.00, 'Pendente');
