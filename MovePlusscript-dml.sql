-- ==========================================
-- PROJETO: APLICATIVO MOVEPLUS
-- ARQUIVO: script-dml.sql
-- ==========================================

CREATE DATABASE aplicativo_moveplus;

USE aplicativo_moveplus;

-- CENARIO 1: Cadastro das formas de pagamento

CREATE TABLE formas_pagamento (
    id_forma INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(50) NOT NULL UNIQUE,
    tipo VARCHAR(30) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    taxa DECIMAL(5,2) DEFAULT 0
);

-- CENARIO 2: Cadastro dos enderecos

CREATE TABLE enderecos (
    id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    rua VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    bairro VARCHAR(60) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    cep VARCHAR(10) NOT NULL
);

-- CENARIO 3: Cadastro dos passageiros

CREATE TABLE passageiros (
    id_passageiro INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL
);

-- CENARIO 4: Cadastro dos motoristas

CREATE TABLE motoristas (
    id_motorista INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cnh VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    data_cadastro DATE NOT NULL
);

-- CENARIO 5: Cadastro dos veiculos

CREATE TABLE veiculos (
    id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
    modelo VARCHAR(60) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    placa VARCHAR(10) NOT NULL UNIQUE,
    ano INT NOT NULL,
    id_motorista INT NOT NULL,

    FOREIGN KEY (id_motorista)
    REFERENCES motoristas(id_motorista),

    CHECK (ano >= 2000)
);

-- CENARIO 6: Registro das corridas

CREATE TABLE corridas (
    id_corrida INT PRIMARY KEY AUTO_INCREMENT,
    id_passageiro INT NOT NULL,
    id_motorista INT NOT NULL,
    id_origem INT NOT NULL,
    id_destino INT NOT NULL,
    data_hora DATETIME NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Solicitada',

    FOREIGN KEY (id_passageiro)
    REFERENCES passageiros(id_passageiro),

    FOREIGN KEY (id_motorista)
    REFERENCES motoristas(id_motorista),

    FOREIGN KEY (id_origem)
    REFERENCES enderecos(id_endereco),

    FOREIGN KEY (id_destino)
    REFERENCES enderecos(id_endereco),

    CHECK (valor >= 0),

    CHECK (status IN ('Solicitada', 'Em andamento', 'Concluida', 'Cancelada'))
);

-- CENARIO 7: Registro dos pagamentos

CREATE TABLE pagamentos (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_corrida INT NOT NULL UNIQUE,
    id_forma INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Aprovado',

    FOREIGN KEY (id_corrida)
    REFERENCES corridas(id_corrida),

    FOREIGN KEY (id_forma)
    REFERENCES formas_pagamento(id_forma),

    CHECK (valor >= 0),

    CHECK (status IN ('Aprovado', 'Pendente', 'Recusado'))
);

-- CENARIO 8: Avaliacoes das corridas

CREATE TABLE avaliacoes (
    id_avaliacao INT PRIMARY KEY AUTO_INCREMENT,
    id_corrida INT NOT NULL UNIQUE,
    id_passageiro INT NOT NULL,
    id_motorista INT NOT NULL,
    nota INT NOT NULL,
    comentario VARCHAR(255),
    data_avaliacao DATE NOT NULL,

    FOREIGN KEY (id_corrida)
    REFERENCES corridas(id_corrida),

    FOREIGN KEY (id_passageiro)
    REFERENCES passageiros(id_passageiro),

    FOREIGN KEY (id_motorista)
    REFERENCES motoristas(id_motorista),

    CHECK (nota BETWEEN 1 AND 5)
);



-- =====================================================
-- PROJETO: APLICATIVO MovePlus
-- ARQUIVO: script-dml.sql
-- =====================================================

USE aplicativo_moveplus;

INSERT INTO passageiros
(nome, cpf, telefone, email, data_nascimento)
VALUES
('Jose Silva', '666.666.666-66', '84991111111', 'jose@email.com', '1990-04-15'),
('Maria Oliveira', '777.777.777-77', '84992222222', 'maria@email.com', '1995-08-20'),
('Ana Costa', '888.888.888-88', '84993333333', 'ana@email.com', '1998-02-10'),
('Pedro Almeida', '999.999.999-99', '84994444444', 'pedro@email.com', '1988-06-25'),
('Juliana Ferreira', '123.456.789-10', '84995555555', 'juliana@email.com', '2000-12-05');

-- =====================================================
-- CENARIO 1 - PREPARACAO PARA O LANCAMENTO
-- =====================================================
-- 1. Cadastro dos passageiros
-- No primeiro dia de funcionamento do aplicativo, cinco passageiros realizaram seus cadastros para aproveitar a promoção de inauguração.
-- Os clientes cadastrados foram: José Silva, nascido em 
-- 15/04/1990; Maria Oliveira, nascida em 20/08/1995; Carlos Santos, nascido em 10/12/1988; Ana Souza, nascida em 25/03/2000; e Pedro Costa, nascido em 18/07/1992.

INSERT INTO formas_pagamento
(descricao, tipo, ativo, taxa)
VALUES
('Cartao de Credito', 'Cartao', TRUE, 2.50),
('Cartao de Debito', 'Cartao', TRUE, 1.50),
('PIX', 'Digital', TRUE, 0.00),
('Dinheiro', 'Presencial', TRUE, 0.00),
('Carteira Digital', 'Digital', TRUE, 1.00);

-- =====================================================
-- CENARIO 2 - ESCOLHENDO A FORMA DE PAGAMENTO
-- =====================================================
-- Os passageiros informaram suas respectivas formas de pagamento: José Silva escolheu Pix; Maria Oliveira escolheu dinheiro;
-- Carlos Santos escolheu cartão de crédito; Ana Souza escolheu Pix; e Pedro Costa escolheu dinheiro.

INSERT INTO enderecos
(rua, numero, bairro, cidade, cep)
VALUES
('Rua das Flores', '100', 'Centro', 'Santa Cruz', '59200-000'),
('Avenida Principal', '250', 'Paraiso', 'Santa Cruz', '59200-001'),
('Rua Nova', '45', 'Maracuja', 'Santa Cruz', '59200-002'),
('Rua da Paz', '300', 'DNER', 'Santa Cruz', '59200-003'),
('Avenida Brasil', '500', 'Centro', 'Santa Cruz', '59200-004'),
('Rua Esperanca', '80', 'Conjunto Conego Monte', 'Santa Cruz', '59200-005'),
('Rua Sao Jose', '120', 'Centro', 'Santa Cruz', '59200-006'),
('Rua do Comercio', '75', 'Paraiso', 'Santa Cruz', '59200-007'),
('Avenida Rio Branco', '210', 'DNER', 'Santa Cruz', '59200-008'),
('Rua da Liberdade', '90', 'Maracuja', 'Santa Cruz', '59200-009');

-- =====================================================
-- CENARIO 3 - DEFININDO OS ENDERECOS
-- =====================================================
-- José Silva: Rua das Flores, nº 125, bairro Centro, Santa Cruz/RN, CEP 59200-000. Destino: Rodoviária de Santa Cruz.
-- Maria Oliveira: Rua João Pessoa, nº 240, bairro Paraíso, Santa Cruz/RN, CEP 59200-000. Destino: Hospital Municipal de Santa Cruz.
-- Carlos Santos: Rua São Francisco, nº 87, bairro Maracujá, Santa Cruz/RN, CEP 59200-000. Destino: Natal/RN.
-- Ana Souza: Rua José Ferreira, nº 56, bairro Cônego Monte, Santa Cruz/RN, CEP 59200-000. Destino: Supermercado RedeMais.
-- Pedro Costa: Rua Padre Cícero, nº 310, bairro DNER, Santa Cruz/RN, CEP 59200-000. Destino: Tangará/RN.

INSERT INTO motoristas
(nome, cpf, cnh, telefone, data_cadastro)
VALUES
('Carlos Eduardo', '111.111.111-11', 'CNH10001', '84990000001', '2026-11-02'),
('Roberto Santos', '222.222.222-22', 'CNH10002', '84990000002', '2026-11-03'),
('Marcos Oliveira', '333.333.333-33', 'CNH10003', '84990000003', '2026-11-04'),
('Anderson Lima', '444.444.444-44', 'CNH10004', '84990000004', '2026-11-05'),
('Felipe Souza', '555.555.555-55', 'CNH10005', '84990000005', '2026-11-06');

-- =====================================================
-- CENARIO 4 - SELECAO DOS MOTORISTAS PARCEIROS
-- =====================================================
-- Após informarem seus endereços e destinos, os passageiros visualizaram os motoristas disponíveis e realizaram suas escolhas. José Silva selecionou João Ferreira;
-- Maria Oliveira selecionou Patrícia Lima;
-- Carlos Santos selecionou Marcos Oliveira; Ana Souza selecionou Ricardo Alves; e Pedro Costa selecionou Felipe Santos.

INSERT INTO veiculos
(modelo, marca, placa, ano, id_motorista)
VALUES
('Onix', 'Chevrolet', 'ABC1D23', 2022, 1),
('HB20', 'Hyundai', 'DEF4G56', 2023, 2),
('Gol', 'Volkswagen', 'GHI7J89', 2021, 3),
('Argo', 'Fiat', 'KLM1N23', 2022, 4),
('Corolla', 'Toyota', 'OPQ4R56', 2024, 5);

-- =====================================================
-- CENARIO 5 - SELECAO DOS VEICULOS
-- =====================================================
-- Cada motorista parceiro foi relacionado ao seu respectivo veículo. João Ferreira utiliza um Chevrolet Onix, ano 2022, cor branca; Patrícia Lima utiliza um Fiat Argo,
-- ano 2023, cor prata; Marcos Oliveira utiliza um Hyundai HB20, ano 2024, cor preta;
-- Ricardo Alves utiliza um toyota SUVs , ano 2023, cor vermelha; e Felipe Santos utiliza um Volkswagen Gol, ano 2022, cor cinza.

INSERT INTO corridas
(id_passageiro, id_motorista, id_origem, id_destino,
 data_hora, valor, status)
VALUES
(1, 1, 1, 2, '2026-11-10 08:00:00', 15.00, 'Concluida'),
(2, 2, 3, 4, '2026-11-10 09:30:00', 20.00, 'Concluida'),
(3, 3, 5, 6, '2026-11-10 11:00:00', 12.50, 'Concluida'),
(4, 4, 7, 8, '2026-11-10 14:00:00', 18.00, 'Concluida'),
(5, 5, 9, 10, '2026-11-10 16:30:00', 25.00, 'Concluida');

-- =====================================================
-- CENARIO 6 - INAUGURACAO E PRIMEIRAS CORRIDAS
-- =====================================================
-- O Move+ inicia oficialmente suas atividades.
-- Jose solicita uma viagem do Centro ao Paraiso.
-- Maria solicita transporte para o bairro DNER.
-- Ana precisa se deslocar para outro endereco da cidade.
-- Pedro e Juliana tambem utilizam o aplicativo.
-- Os cinco motoristas aceitam as solicitacoes e
-- todas as viagens registradas sao concluidas.

INSERT INTO pagamentos
(id_corrida, id_forma, valor, data_pagamento, status)
VALUES
(1, 1, 15.00, '2026-11-10 08:30:00', 'Aprovado'),
(2, 3, 20.00, '2026-11-10 10:00:00', 'Aprovado'),
(3, 4, 12.50, '2026-11-10 11:30:00', 'Aprovado'),
(4, 2, 18.00, '2026-11-10 14:30:00', 'Aprovado'),
(5, 5, 25.00, '2026-11-10 17:00:00', 'Aprovado');

-- =====================================================
-- CENARIO 7 - PROCESSAMENTO DOS PAGAMENTOS
-- =====================================================
-- Depois que as viagens sao finalizadas, o sistema
-- registra os pagamentos realizados pelos passageiros.
-- Cada usuario escolhe uma modalidade diferente,
-- demonstrando as opcoes oferecidas pelo aplicativo.

INSERT INTO avaliacoes
(id_corrida, id_passageiro, id_motorista,
 nota, comentario, data_avaliacao)
VALUES
(1, 1, 1, 5, 'Motorista educado e chegou no horario combinado.', '2026-11-10'),
(2, 2, 2, 5, 'Viagem tranquila e atendimento excelente.', '2026-11-10'),
(3, 3, 3, 4, 'Boa experiencia, motorista dirigiu com cuidado.', '2026-11-10'),
(4, 4, 4, 5, 'Excelente atendimento e viagem confortavel.', '2026-11-10'),
(5, 5, 5, 5, 'Motorista atencioso e percurso realizado rapidamente.', '2026-11-10');

-- =====================================================
-- CENARIO 8 - AVALIACAO DA EXPERIENCIA DOS PASSAGEIROS
-- =====================================================
-- Ao final de cada viagem, os passageiros recebem
-- a oportunidade de avaliar o servico prestado.
-- As avaliacoes ajudam a empresa a acompanhar a
-- qualidade do atendimento dos motoristas parceiros.

