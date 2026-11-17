# Entrar

- Slug: `sign-in`
- Status: `em execução` — implementada em 2026-11-16 (`mayahtrip-app`). AC-2/3/4/5 verificados por teste de widget automatizado e por execução real no macOS (dois bugs reais achados e corrigidos por essa inspeção: tema do sistema vazando na paleta fixa do login, e kicker sem maiúsculas). AC-1 (carrossel) e AC-6/AC-7 ainda pendem de inspeção lado a lado mais fina com os prints de `.docs/prototype/screens/`.
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/01-login.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: nenhuma
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `01-login.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Passos início e e-mail do login: Google, e-mail e senha, manter conectado, olho da senha. Os links para criar conta, esqueci a senha e convidado só navegam; o destino é de outra spec.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `01-login.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Passos início e e-mail do login: Google, e-mail e senha, manter conectado, olho da senha. Os links para criar conta, esqueci a senha e convidado só navegam; o destino é de outra spec.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Passos início e e-mail do login: Google, e-mail e senha, manter conectado, olho da senha. Os links para criar conta, esqueci a senha e convidado só navegam; o destino é de outra spec.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

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

Estados desta fatia:

- Vazio: o que `01-login.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado o passo início, quando a tela abre, então o carrossel troca as 5 fotos a cada 4 s, com kicker lima e o título “Planeje menos. / Viaje mais.”; verificado por inspeção no frame 390×844 contra o protótipo.
- [ ] **AC-2** — Dado e-mail e senha preenchidos no protótipo, quando a pessoa toca Entrar, então o botão mostra o indicador por 900 ms, cria sessão mocada e abre o Início com o aviso “Bem-vindo de volta, {primeiro nome}”; verificado por teste de widget.
- [ ] **AC-3** — Dado o campo senha com texto, quando a pessoa toca o olho, então a visibilidade alterna e o texto permanece; verificado por teste de widget.
- [ ] **AC-4** — Dado “Manter conectado” marcado (padrão), quando a pessoa entra e reabre o app, então a abertura segue para o Início; verificado por teste de widget.
- [ ] **AC-5** — Dado o passo e-mail, quando a pessoa toca voltar, então volta ao passo início sem perder a sessão ainda inexistente; verificado por teste de widget.
- [ ] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `01-login.md`; verificado por inspeção lado a lado.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; verificado por inspeção.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `01-login.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| P-1 | premissa | A fundação visual da spec `abertura` já existe quando esta fatia for implementada, salvo na própria abertura. | app | a spec `abertura` concluída |

## 9. Impactos

| Área | Impacto |
| --- | --- |
| Arquitetura/contratos | Tela Flutter em `mayahtrip-app`. Sem contrato de API nesta fatia. |
| Dados | Estado em memória, igual ao protótipo. Nada é gravado em servidor. |
| UI/UX e acessibilidade | Frame 390×844. Tipografia Plus Jakarta Sans e Instrument Serif. Reduzir movimento zera a duração. |
| Segurança | Sessão mocada. Sem senha real, sem segredo, sem PAN de cartão. |
| Observabilidade | Não se aplica: não há chamada de rede nesta fatia. |

## 10. Plano de testes

- Widget/unitário: cada AC com dado de entrada do protótipo.
- Integração: não se aplica enquanto os dados forem mocados.
- Manual no frame 390×844: abrir o protótipo por HTTP e comparar esta tela, inclusive o movimento.
- Casos de borda: vazio, erro escrito no doc, papel sem permissão e reduzir movimento.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| --- | --- | --- | --- |
| A tela copia a vizinha e estoura o escopo | média | alto | AC e seção 5.2 nomeiam as outras specs |
| Medida do protótipo diverge do BUSINESS | baixa | alto | Parar e registrar, decisão D-1 |

- Rollback: remover a rota e os widgets desta fatia. As specs vizinhas continuam.
- Critério para abortar: um AC falha na inspeção lado a lado ou a implementação precisa inventar um `A DEFINIR`.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| --- | --- | --- | --- |
| 3. “Manter conectado” marcado → sessão persiste entre aberturas (ver `00-abertura.md`). Desmarcado: `A DEFINIR` (duração da sessão). | não | produto | antes do refine-spec |
| 4. Não há login com Facebook nem Apple no momento. Apple: `A DEFINIR`. | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `sign-in` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

## 14. Definition of Ready

- [x] Problema, usuário e valor claros
- [x] Escopo e fora de escopo explícitos
- [x] Critérios de aceite mensuráveis (`AC-*`)
- [x] Premissas com dono e validação
- [x] Impactos mapeados
- [x] Plano de testes definido
- [x] Riscos e rollback definidos
- [x] Sem pergunta bloqueante em aberto
- [ ] Spec revisada com `refine-spec`
- [ ] Aprovada pelo responsável

Dependências para implementar, não para ler esta spec:

- Nenhuma. Esta fatia não espera outra spec para ser verificada.
