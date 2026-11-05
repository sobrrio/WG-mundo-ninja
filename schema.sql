-- ========================================================
-- WG MUNDO NINJA: ERA DA FUNDAÇÃO
-- Schema PostgreSQL para Supabase
-- ========================================================

-- Habilitar extensão de UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Tabela de Vilas
CREATE TABLE IF NOT EXISTS public.vilas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(100) NOT NULL UNIQUE,
    pais VARCHAR(100) NOT NULL,
    bioma VARCHAR(100) NOT NULL,
    daimyo VARCHAR(100) NOT NULL,
    bonus_territorial TEXT,
    penalidade_territorial TEXT,
    ano_fundacao INT DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Tabela de Kages / Líderes
CREATE TABLE IF NOT EXISTS public.kages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vila_id UUID REFERENCES public.vilas(id) ON DELETE CASCADE,
    nome VARCHAR(100) NOT NULL,
    cla VARCHAR(100) NOT NULL,
    titulo VARCHAR(50) DEFAULT 'Fundador',
    chakra_max INT DEFAULT 100,
    chakra_atual INT DEFAULT 100,
    especialidade VARCHAR(150),
    jutsus_conhecidos JSONB DEFAULT '[]'::jsonb,
    itens_preparados JSONB DEFAULT '[]'::jsonb,
    status VARCHAR(50) DEFAULT 'Operacional',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Tabela de Recursos (Por Vila / Ano)
CREATE TABLE IF NOT EXISTS public.recursos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vila_id UUID REFERENCES public.vilas(id) ON DELETE CASCADE,
    ano INT NOT NULL,
    ryo INT DEFAULT 2000,
    comida INT DEFAULT 1500,
    madeira INT DEFAULT 1000,
    pedra INT DEFAULT 800,
    ferro INT DEFAULT 500,
    ouro INT DEFAULT 0,
    mdo_total INT DEFAULT 6,
    mdo_disponivel INT DEFAULT 6,
    populacao INT DEFAULT 5000,
    modificador_estacao JSONB DEFAULT '{"nome": "Colheita da Primavera", "bonus_comida": 0.15}'::jsonb,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(vila_id, ano)
);

-- 4. Tabela de Esquadrões
CREATE TABLE IF NOT EXISTS public.esquadroes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vila_id UUID REFERENCES public.vilas(id) ON DELETE CASCADE,
    nome VARCHAR(100) NOT NULL,
    rank VARCHAR(20) NOT NULL CHECK (rank IN ('Genin', 'Chunin', 'Jonin', 'Elite', 'Mercenário')),
    quantidade INT DEFAULT 4,
    status VARCHAR(50) DEFAULT 'Disponível' CHECK (status IN ('Disponível', 'Em Missão', 'Apto', 'Ferido', 'Em Treinamento')),
    localizacao VARCHAR(100) DEFAULT 'Vila',
    missao_atual VARCHAR(150),
    equipamento TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Tabela de Pesquisas e Estruturas
CREATE TABLE IF NOT EXISTS public.pesquisas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vila_id UUID REFERENCES public.vilas(id) ON DELETE CASCADE,
    nome VARCHAR(120) NOT NULL,
    categoria VARCHAR(50) CHECK (categoria IN ('Infraestrutura', 'Militar', 'Científico')),
    ano_inicio INT NOT NULL,
    duracao_anos INT DEFAULT 1,
    concluida BOOLEAN DEFAULT false,
    beneficio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. Tabela de Ordens Secretas (Turno Anual)
CREATE TABLE IF NOT EXISTS public.ordens_secretas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vila_id UUID REFERENCES public.vilas(id) ON DELETE CASCADE,
    ano INT NOT NULL,
    autor VARCHAR(100) NOT NULL,
    ordens_economicas TEXT,
    ordens_militares TEXT,
    ordens_diplomaticas TEXT,
    ordens_espionagem TEXT,
    status_resolucao VARCHAR(50) DEFAULT 'Pendente' CHECK (status_resolucao IN ('Pendente', 'Em Análise', 'Processada')),
    resposta_mestre TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(vila_id, ano)
);

-- 7. Tabela de Missões das Cinco Cortes (Daimyōs)
CREATE TABLE IF NOT EXISTS public.missoes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    titulo VARCHAR(150) NOT NULL,
    corte_daimyo VARCHAR(100) NOT NULL,
    rank VARCHAR(5) CHECK (rank IN ('D', 'C', 'B', 'A', 'S')),
    recompensa_ryo INT NOT NULL,
    recompensa_recursos TEXT,
    reputacao_ganho INT DEFAULT 5,
    descricao TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'Disponível' CHECK (status IN ('Disponível', 'Em Andamento', 'Concluída', 'Falha')),
    vila_atribuida_id UUID REFERENCES public.vilas(id),
    ano_vigente INT DEFAULT 3,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 8. Tabela de Crônicas do Mundo
CREATE TABLE IF NOT EXISTS public.cronicas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ano INT NOT NULL,
    capitulo VARCHAR(150) NOT NULL,
    conteudo TEXT NOT NULL,
    visibilidade VARCHAR(30) DEFAULT 'Pública' CHECK (visibilidade IN ('Pública', 'Reservada')),
    reacoes JSONB DEFAULT '{"fogo": 0, "aplausos": 0, "espada": 0, "olho": 0}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ========================================================
-- SEED DATA: ANO 3 - ERA DA FUNDAÇÃO
-- ========================================================

-- Inserir Vilas Fundadoras
INSERT INTO public.vilas (nome, pais, bioma, daimyo, bonus_territorial, penalidade_territorial, ano_fundacao) VALUES
('Folha (Konohagakure)', 'País do Fogo', 'Florestas Ancestrais', 'Masanori Akitsu', '+25% Comida e +25% Madeira', '-25% Pedra', 1),
('Areia (Sunagakure)', 'País do Vento', 'Deserto e Dunas', 'Sayuri Kazehara', '+25% Ferro e +25% Comércio', '-25% Comida e Madeira', 1),
('Nuvem (Kumogakure)', 'País do Raio', 'Cumes Montanhosos', 'Akemi Narukami', '+25% Pedra e Táticas de Altitude', '-15% Agricultura Plana', 1),
('Geada (Shimogakure)', 'País da Geada', 'Tundra Congelada', 'Lorde de Shimo', 'Custo mov. dobrado p/ invasores', '-20% Vegetação Natural', 1),
('Cachoeira (Takigakure)', 'País da Cachoeira', 'Gargantas e Quedas D''água', 'Lorde de Taki', 'Defesa natural fortificada contra invasão', '-15% Comércio Exterior', 1)
ON CONFLICT (nome) DO NOTHING;

-- Inserir Kages Fundadores
DO $$
DECLARE
    v_folha UUID; v_areia UUID; v_nuvem UUID; v_geada UUID; v_taki UUID;
BEGIN
    SELECT id INTO v_folha FROM public.vilas WHERE nome = 'Folha (Konohagakure)';
    SELECT id INTO v_areia FROM public.vilas WHERE nome = 'Areia (Sunagakure)';
    SELECT id INTO v_nuvem FROM public.vilas WHERE nome = 'Nuvem (Kumogakure)';
    SELECT id INTO v_geada FROM public.vilas WHERE nome = 'Geada (Shimogakure)';
    SELECT id INTO v_taki FROM public.vilas WHERE nome = 'Cachoeira (Takigakure)';

    INSERT INTO public.kages (vila_id, nome, cla, especialidade, status) VALUES
    (v_folha, 'Raizen', 'Senju', 'Doton (Terra) & Resistência Física Robusta', 'Operacional'),
    (v_areia, 'Satori', 'Marionetista', 'Kugutsu (Fios de Chakra, Lâminas Ocultas, Veneno)', 'Operacional'),
    (v_nuvem, 'Aburame Raiden', 'Aburame', 'Kikaichū (Reconhecimento & Drenagem)', 'Operacional'),
    (v_geada, 'Dorutan Tenkyô', 'Hyūga', 'Byakugan (Visão de 360°, Fluxo de Chakra)', 'Operacional'),
    (v_taki, 'Tsuchinoko', 'Especialista em Taijutsu', 'Taijutsu de Alto Impacto & Agilidade', 'Operacional')
    ON CONFLICT DO NOTHING;

    -- Inserir Recursos do Ano 3
    INSERT INTO public.recursos (vila_id, ano, ryo, comida, madeira, pedra, ferro, ouro, mdo_total, mdo_disponivel, populacao) VALUES
    (v_folha, 3, 3500, 3200, 2400, 700, 900, 100, 8, 8, 8500),
    (v_areia, 3, 4200, 1800, 900, 1500, 2100, 300, 7, 7, 7200),
    (v_nuvem, 3, 3100, 1900, 1100, 2400, 1400, 150, 7, 7, 6800),
    (v_geada, 3, 2200, 2400, 1200, 1100, 700, 50, 6, 6, 4200),
    (v_taki, 3, 2600, 2100, 1300, 1000, 800, 50, 6, 6, 4900)
    ON CONFLICT (vila_id, ano) DO NOTHING;

    -- Inserir Missões de Demonstração das Cinco Cortes
    INSERT INTO public.missoes (titulo, corte_daimyo, rank, recompensa_ryo, recompensa_recursos, descricao) VALUES
    ('Escolta de Caravana de Grãos da Primavera', 'Masanori Akitsu (Fogo)', 'C', 1200, '+300 Comida', 'Garantir trânsito seguro de comboio agrícola entre os vales centrais e o Palácio do Cedro Rubro contra bandidos ronin.'),
    ('Mapeamento Mineral de Jazidas de Enxofre', 'Sayuri Kazehara (Vento)', 'B', 2500, '+500 Ferro', 'Incursão e prospecção de minas secretas nas ravinas do Deserto Ocidental com contenção de tempestades.'),
    ('Patrulha de Fronteira no Cume das Nuvens', 'Akemi Narukami (Raio)', 'C', 1500, '+200 Pedra', 'Vigilância contra escaramuças de clãs renegados que ameaçam os desfiladeiros estratégicos.')
    ON CONFLICT DO NOTHING;
END $$;
