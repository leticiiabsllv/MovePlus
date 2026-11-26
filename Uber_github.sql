-- ==========================================
-- PROJETO: APLICATIVO MovePlus
-- ARQUIVO: script-ddl.sql
-- ==========================================

CREATE DATABASE aplicativo_uber;

USE aplicativo_moveplus;

-- CENARIO 1: Cadastro das formas de pagamento
CREATE TABLE formas_pagamento (
   -- o auto_increment gera automaticamente valores numéricos sequenciais e únicos 
    --para uma coluna sempre que um novo registro é inserido.
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
    -- BETWEEN é um operador usado na cláusula WHERE para 
    -- filtrar registros dentro de um intervalo inclusivo
    CHECK (nota BETWEEN 1 AND 5)
);

