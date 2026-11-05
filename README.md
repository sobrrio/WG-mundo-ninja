# WG Mundo Ninja — Era da Fundação
### Arquitetura de Produção: GitHub + Supabase + Netlify

Esta é a aplicação completa e independente do **WG Mundo Ninja — Era da Fundação**, projetada para rodar sem depender do ChatGPT ou de qualquer plano pago.

---

## 🚀 Como subir em 5 minutos (100% Grátis)

### 1. Criar o Banco de Dados no Supabase
1. Acesse [https://supabase.com](https://supabase.com) e crie uma conta gratuita.
2. Clique em **"New Project"**, dê o nome `wg-mundo-ninja` e defina uma senha de banco.
3. No menu lateral esquerdo, vá em **SQL Editor** -> **New Query**.
4. Abra o arquivo `schema.sql` deste pacote, cole todo o código e clique em **Run**.
5. Vá em **Project Settings** -> **API** e anote a sua **Project URL** e a **anon public key**.

### 2. Subir o Código no GitHub
1. Crie um novo repositório no seu GitHub (ex: `wg-mundo-ninja`).
2. Suba todos os arquivos desta pasta (`index.html`, `schema.sql`, `README.md`, `netlify.toml`).

### 3. Publicar no Netlify
1. Acesse [https://www.netlify.com](https://www.netlify.com) e conecte com sua conta do GitHub.
2. Clique em **"Add new site"** -> **"Import an existing project"** -> selecione seu repositório `wg-mundo-ninja`.
3. Deixe as configurações de Build vazias (é um site estático puro e rápido) e clique em **Deploy site**.
4. Em menos de 30 segundos seu link público estará no ar (ex: `https://wg-mundo-ninja.netlify.app`).

### 4. Conectar a Aplicação ao Banco
Abra seu site no Netlify, clique na engrenagem **"Configurações / Supabase"** no topo da página e cole sua **Project URL** e sua **anon public key**. Pronto! Seu jogo está sincronizado e operando em nuvem em tempo real!
