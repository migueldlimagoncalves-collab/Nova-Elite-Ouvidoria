# Ouvidoria Estudantil — Chapa Nova Elite

Protótipo inicial responsivo para publicação no GitHub Pages ou hospedagem estática. O projeto inclui formulário público, escolha de envio anônimo/identificado, painel administrativo com autenticação Supabase e esquema de banco de dados com Row Level Security.

## Importante antes de publicar

O site **não está conectado nem pronto para receber manifestações** até completar a configuração abaixo. Não publique o link para uso real antes de testar envio, login, permissões e e-mail. O modo anônimo evita solicitar nome/contato, mas não garante anonimato técnico absoluto: hospedagem, banco e serviços podem registrar dados técnicos.

## 1. Criar banco e autenticação

1. Crie uma conta/projeto no Supabase.
2. Abra SQL Editor e execute `supabase/schema.sql`.
3. Em Authentication > Users, crie as contas dos administradores com senhas fortes.
4. Copie o UUID de cada usuário autorizado e, no SQL Editor, execute:
   ```sql
   insert into public.admin_users (user_id)
   values ('COLE-O-UUID-DO-USUARIO-AQUI');
   ```
5. Em Project Settings > API, copie Project URL e chave `anon`/publishable. Nunca use a chave `service_role` no navegador.
6. Edite `index.html` e substitua `COLE_AQUI_A_URL_DO_PROJETO` e `COLE_AQUI_A_CHAVE_ANON_PUBLICA`.

## 2. E-mail de notificação

O formulário salva no banco, mas o envio de e-mail ainda precisa ser configurado. Para não expor credenciais no navegador, use uma Edge Function do Supabase ou um serviço de automação confiável. Configure um provedor de e-mail, armazene a chave como segredo no servidor e dispare uma notificação mínima (por exemplo, “Nova manifestação recebida”, sem o texto do relato). Não coloque chaves privadas no HTML nem no GitHub.

O arquivo `supabase/functions/notify-new-report/index.ts` é um ponto de partida ilustrativo; exige configuração e teste antes de uso. O jeito mais seguro é chamar a função a partir de um trigger/integração server-side autenticada, sem permitir que visitantes enviem e-mails arbitrários.

## 3. Publicar

1. Crie um repositório GitHub, por exemplo `nova-elite-ouvidoria`.
2. Envie `index.html` e a pasta `supabase`.
3. Em Settings > Pages, habilite publicação a partir da branch principal e pasta `/root`.
4. Aguarde o endereço do GitHub Pages e coloque-o na bio do Instagram.

## 4. Testes obrigatórios

- Enviar um relato anônimo e outro identificado de teste.
- Confirmar que visitantes não conseguem consultar relatos.
- Confirmar que apenas os UUIDs inseridos em `admin_users` acessam o painel.
- Confirmar que usuário sem permissão não consegue ler/alterar dados via API.
- Testar no celular e verificar a notificação de e-mail.
- Apagar os dados de teste antes de abrir ao público.

## Privacidade e uso por estudantes

- Definam quem responde pela ouvidoria e quem pode acessar o painel.
- Coletem apenas os dados necessários e estabeleçam prazo de retenção/exclusão.
- Não prometam anonimato absoluto; expliquem os limites técnicos.
- Evitem usar este canal para emergências ou denúncias que exijam atendimento especializado imediato.
- Como pode haver menores de idade, alinhem o uso com um adulto responsável e as regras da escola. A página deixa claro que é um canal da chapa candidata, não um canal oficial da escola.
