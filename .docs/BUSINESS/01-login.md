# 01 — Login

## Objetivo
Permitir que o usuário entre com **Google** ou **e-mail e senha**, crie conta ou explore como convidado.

## Estrutura da tela
A tela tem duas camadas:

### Camada de fundo (carrossel de fotos)
- Fundo `#120F2A` com **5 fotos** em tela cheia, trocando a cada **4 s** (ciclo de 20 s), em ordem:
  1. Roma · Fontana di Trevi
  2. Lisboa · Elétrico 28
  3. Paris · Rio Sena
  4. Londres · Westminster
  5. Paris · Torre Eiffel
- Cada foto entra com esmaecimento e zoom suave (escala 1,12 → 1).
- Gradiente sobre as fotos (de cima para baixo): `rgba(18,15,42,.55)` 0% → transparente 22% → `.2` 40% → `.85` 70% → `.95` 100%.
- **Topo** (56 px do topo, 22 px das laterais): símbolo 30 px + logotipo branco 112 px.
- **Legenda da foto atual**: kicker lima `#C9FF27` (11 px, 800, maiúsculas), sincronizada com a foto.
- **Título**: Instrument Serif 46 px, branco, line-height 1: “Planeje menos.” / “*Viaje mais.*” (2ª linha em itálico).
- Legenda + título ficam 340 px acima da base (352 px no modo e-mail) e somem (opacidade 0) nos demais passos (cadastro, verificação, senha).

### Painel inferior (folha fixa)
- Fundo branco, raio 32 px no topo, espaçamento 26 px (topo) / 22 px (laterais) / 34 px (base), sombra `0 -12px 40px rgba(18,15,42,.25)`.
- Entra subindo 40% + esmaecendo em 700 ms. Cada troca de passo anima o conteúdo subindo 14 px em 450 ms.

## Passo “início”
De cima para baixo, espaçamento 12 px:
1. **Continuar com Google** — botão 54 px, raio 27 px, fundo branco, borda `#E5E3EC`, logo do Google 20 px + texto 15 px/700.
2. **Entrar com e-mail** — botão primário `#2B207F`, 54 px, raio 27 px, ícone de envelope 18 px.
3. **Explorar como convidado** — link de 46 px, texto 15 px/700 cor `#15122E`, ícone de bússola 18 px e seta 16 px em `#2B207F` → ver `04-modo-convidado.md`.
4. “Novo por aqui?” (13 px, `#5E5A73`) + link **Criar conta grátis** (`#2B207F`, 700) → `02-cadastro-e-verificacao.md`.
5. Rodapé 12 px centralizado: “Ao continuar, você aceita os <u>Termos de uso</u> e a <u>Política de privacidade</u>.”

## Passo “e-mail”
1. Título “Bem-vindo de volta” (h2) + botão voltar 38 × 38 px (fundo `#F4F3F8`) à direita → volta ao início.
2. Campo **E-mail** (54 px, raio 18 px).
3. Campo **Senha** (54 px, raio 18 px) com botão de olho à direita (40 × 40 px) que alterna mostrar/ocultar sem perder o texto.
4. Linha: caixa **Manter conectado** (18 px, marcada por padrão, cor `#2B207F`) à esquerda; link **Esqueci a senha** à direita → `03-recuperar-senha.md`.
5. Botão **Entrar** (primário, 54 px).
6. “Ainda não tem conta?” + link **Criar conta**.

## Regras de negócio
1. Google ou e-mail válidos → cria sessão, vai ao Início e mostra o aviso “Bem-vindo de volta, {primeiro nome}”.
2. Enquanto autentica (no protótipo, 900 ms), o botão acionado mostra um indicador giratório (18 px, borda 2,5 px, topo lima ou roxo) e fica desativado.
3. “Manter conectado” marcado → sessão persiste entre aberturas (ver `00-abertura.md`). Desmarcado: `A DEFINIR` (duração da sessão).
4. Não há login com Facebook nem Apple no momento. Apple: `A DEFINIR`.

## Erros
- Mensagens para e-mail/senha incorretos, conta inexistente e bloqueio por tentativas: `A DEFINIR` (o protótipo não simula erro de login).

## A DEFINIR
- Limite de tentativas de senha e bloqueio temporário.
- Conteúdo de Termos de uso e Política de privacidade.
