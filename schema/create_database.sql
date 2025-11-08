-- =============================================
-- SISTEMA DE GESTÃO DE OFICINA MECÂNICA
-- Modelo Lógico de Banco de Dados
-- =============================================

CREATE DATABASE IF NOT EXISTS oficina_mecanica_db;
USE oficina_mecanica_db;

-- =============================================
-- TABELA: Customer (Cliente)
-- =============================================
CREATE TABLE Customer (
    idCustomer INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF CHAR(11) NOT NULL UNIQUE,
    Contact VARCHAR(20),
    Address VARCHAR(150),
    DataCadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_customer_cpf (CPF)
);

-- =============================================
-- TABELA: Vehicle_OS (Veículo)
-- =============================================
CREATE TABLE Vehicle_OS (
    idVehicle_OS INT AUTO_INCREMENT PRIMARY KEY,
    Customer_idCustomer INT NOT NULL,
    Model VARCHAR(80) NOT NULL,
    License VARCHAR(25) NOT NULL UNIQUE,
    Year YEAR NOT NULL,
    Vehicle_condition VARCHAR(100),
    DataCadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_vehicle_customer FOREIGN KEY (Customer_idCustomer) 
        REFERENCES Customer(idCustomer)
        ON DELETE RESTRICT,
    
    INDEX idx_vehicle_license (License),
    INDEX idx_vehicle_customer (Customer_idCustomer)
);

-- =============================================
-- TABELA: Service (Serviço)
-- =============================================
CREATE TABLE Service (
    idService INT AUTO_INCREMENT PRIMARY KEY,
    Customer_idCustomer INT NOT NULL,
    Service_Type ENUM(
        'Revisão',
        'Manutenção Preventiva',
        'Manutenção Corretiva',
        'Troca de Óleo',
        'Alinhamento',
        'Balanceamento',
        'Freios',
        'Suspensão',
        'Motor',
        'Elétrica',
        'Ar Condicionado',
        'Funilaria',
        'Pintura'
    ) NOT NULL,
    Description TEXT,
    Deadline DATE NOT NULL,
    Value DECIMAL(10,2) NOT NULL,
    Status ENUM('Aguardando', 'Em Andamento', 'Concluído', 'Cancelado') DEFAULT 'Aguardando',
    DataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_service_customer FOREIGN KEY (Customer_idCustomer) 
        REFERENCES Customer(idCustomer)
        ON DELETE RESTRICT,
    
    INDEX idx_service_status (Status),
    INDEX idx_service_deadline (Deadline),
    INDEX idx_service_customer (Customer_idCustomer)
);

-- =============================================
-- TABELA: OS (Ordem de Serviço)
-- =============================================
CREATE TABLE OS (
    idOS INT AUTO_INCREMENT PRIMARY KEY,
    NumeroOS VARCHAR(20) NOT NULL UNIQUE,
    Description VARCHAR(100),
    DataEmissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DataConclusao DATETIME,
    Status ENUM('Aberta', 'Em Execução', 'Aguardando Peças', 'Concluída', 'Cancelada') DEFAULT 'Aberta',
    ValorTotal DECIMAL(10,2) DEFAULT 0.00,
    
    INDEX idx_os_numero (NumeroOS),
    INDEX idx_os_status (Status)
);

-- =============================================
-- TABELA: OS_Service (Relacionamento N:M)
-- Uma OS pode ter vários serviços e um serviço pode estar em várias OS
-- =============================================
CREATE TABLE OS_Service (
    idOS_Service INT AUTO_INCREMENT PRIMARY KEY,
    OS_idOS INT NOT NULL,
    Service_idService INT NOT NULL,
    QuantidadeHoras DECIMAL(5,2),
    ValorServico DECIMAL(10,2),
    
    CONSTRAINT fk_os_service_os FOREIGN KEY (OS_idOS) 
        REFERENCES OS(idOS)
        ON DELETE CASCADE,
    CONSTRAINT fk_os_service_service FOREIGN KEY (Service_idService) 
        REFERENCES Service(idService)
        ON DELETE CASCADE,
    
    UNIQUE KEY unique_os_service (OS_idOS, Service_idService)
);

-- =============================================
-- TABELA: Mechanic_team (Equipe de Mecânicos)
-- =============================================
CREATE TABLE Mechanic_team (
    idMechannic_team INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Mec_specialty VARCHAR(50) NOT NULL,
    Address VARCHAR(45),
    Telefone VARCHAR(20),
    DataCadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_mechanic_specialty (Mec_specialty)
);

-- =============================================
-- TABELA: Service_Mechanic (Relacionamento N:M)
-- Serviços executados por equipes de mecânicos
-- =============================================
CREATE TABLE Service_Mechanic (
    idService_Mechanic INT AUTO_INCREMENT PRIMARY KEY,
    Service_idService INT NOT NULL,
    Mechanic_team_idMechannic_team INT NOT NULL,
    DataInicio DATETIME,
    DataConclusao DATETIME,
    HorasTrabalhadas DECIMAL(5,2),
    
    CONSTRAINT fk_service_mechanic_service FOREIGN KEY (Service_idService) 
        REFERENCES Service(idService)
        ON DELETE CASCADE,
    CONSTRAINT fk_service_mechanic_team FOREIGN KEY (Mechanic_team_idMechannic_team) 
        REFERENCES Mechanic_team(idMechannic_team)
        ON DELETE RESTRICT,
    
    INDEX idx_service_mechanic_service (Service_idService),
    INDEX idx_service_mechanic_team (Mechanic_team_idMechannic_team)
);

-- =============================================
-- TABELA: Payment (Pagamento)
-- =============================================
CREATE TABLE Payment (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    OS_idOS INT NOT NULL,
    Service_idService INT,
    Customer_idCustomer INT NOT NULL,
    Pay_method ENUM(
        'Dinheiro',
        'Cartão Crédito',
        'Cartão Débito',
        'PIX',
        'Boleto',
        'Transferência'
    ) NOT NULL,
    ValorPago DECIMAL(10,2) NOT NULL,
    DataPagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    StatusPagamento ENUM('Pendente', 'Aprovado', 'Recusado', 'Estornado') DEFAULT 'Pendente',
    
    CONSTRAINT fk_payment_os FOREIGN KEY (OS_idOS) 
        REFERENCES OS(idOS)
        ON DELETE RESTRICT,
    CONSTRAINT fk_payment_service FOREIGN KEY (Service_idService) 
        REFERENCES Service(idService)
        ON DELETE SET NULL,
    CONSTRAINT fk_payment_customer FOREIGN KEY (Customer_idCustomer) 
        REFERENCES Customer(idCustomer)
        ON DELETE RESTRICT,
    
    INDEX idx_payment_os (OS_idOS),
    INDEX idx_payment_status (StatusPagamento),
    INDEX idx_payment_customer (Customer_idCustomer)
);

-- =============================================
-- TABELA: Pecas (Peças utilizadas)
-- Tabela adicional para controle de peças
-- =============================================
CREATE TABLE Pecas (
    idPeca INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    ValorUnitario DECIMAL(10,2) NOT NULL,
    QuantidadeEstoque INT DEFAULT 0,
    Fornecedor VARCHAR(100),
    
    INDEX idx_peca_nome (Nome)
);

-- =============================================
-- TABELA: OS_Pecas (Peças utilizadas na OS)
-- =============================================
CREATE TABLE OS_Pecas (
    idOS_Pecas INT AUTO_INCREMENT PRIMARY KEY,
    OS_idOS INT NOT NULL,
    Pecas_idPeca INT NOT NULL,
    Quantidade INT NOT NULL DEFAULT 1,
    ValorUnitario DECIMAL(10,2) NOT NULL,
    ValorTotal DECIMAL(10,2) GENERATED ALWAYS AS (Quantidade * ValorUnitario) STORED,
    
    CONSTRAINT fk_os_pecas_os FOREIGN KEY (OS_idOS) 
        REFERENCES OS(idOS)
        ON DELETE CASCADE,
    CONSTRAINT fk_os_pecas_peca FOREIGN KEY (Pecas_idPeca) 
        REFERENCES Pecas(idPeca)
        ON DELETE RESTRICT,
    
    INDEX idx_os_pecas_os (OS_idOS),
    INDEX idx_os_pecas_peca (Pecas_idPeca)
);
