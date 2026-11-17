# Abertura

- Slug: `abertura`
- Status: `em execução` — implementada em 2026-11-16 (`mayahtrip-app`, AC-1/2/3/6 verificados por teste de widget automatizado; AC-4/AC-5 — coreografia e pixel exatos — ainda pendem de inspeção manual lado a lado num device real, ver `plan/abertura-plan.md` e relatório da sessão). ADR `adrs/0001-fontes-e-tokens-de-cor.md`.
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/00-abertura.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: nenhuma
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `00-abertura.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Só a abertura: marca, tempos e a decisão sessão → Início ou Login. Tokens, fontes e curvas de movimento nascem aqui e as outras specs reutilizam.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `00-abertura.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Só a abertura: marca, tempos e a decisão sessão → Início ou Login. Tokens, fontes e curvas de movimento nascem aqui e as outras specs reutilizam.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Só a abertura: marca, tempos e a decisão sessão → Início ou Login. Tokens, fontes e curvas de movimento nascem aqui e as outras specs reutilizam.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Objetivo
Apresentar a marca enquanto o app carrega e decidir o destino do usuário: **Início** (sessão ativa) ou **Login** (sem sessão).

## Regras de negócio
1. A abertura sempre aparece ao iniciar o app.
2. Duração total: **2,7 s** até começar a saída; a saída dura **420 ms**.
3. Ao terminar:
   - com **sessão ativa** → vai para `05-inicio.md` (sem passar pelo login);
   - sem sessão → vai para `01-login.md`.
4. Não há interação na abertura (nenhum botão).
5. Sessão “ativa” é criada ao entrar com Google/e-mail, ao concluir o cadastro ou ao criar conta a partir do modo convidado; é apagada ao sair (`28-perfil.md`). Expiração da sessão por tempo: `A DEFINIR`.

## Layout
- Fundo sólido `#120F2A` ocupando a tela toda.
- **Traço decorativo**: curva lima `#C9FF27`, 2 px, pontas arredondadas, opacidade 55%, partindo da borda esquerda (x −20, y 250 numa tela de 390 × 844) até perto do centro (x 160, y 398).
- **Bloco central** (centralizado vertical e horizontalmente):
  1. Símbolo da marca, **76 px**, todo em lima `#C9FF27` (pontos + avião).
  2. Logotipo “mayahtrip” em branco, **178 px** de largura, 18 px abaixo do símbolo.
  3. Frase em Instrument Serif **22 px**, cor `#C9C6DA`, 14 px abaixo: “Sua viagem, *inteira*, num só lugar.” — a palavra “inteira” em itálico e lima.
- **Barra de progresso**: 120 × 3 px, centralizada, 64 px acima da base; trilho branco 12%; preenchimento lima, raio 2 px.

## Animações (em sequência)
| Elemento | Início | Duração | Efeito |
| --- | --- | --- | --- |
| Traço | 0,1 s | 1,0 s | Desenha da esquerda para a direita (`cubic-bezier(.65,0,.35,1)`); aos 1,6 s esmaece até 12% em 0,8 s |
| Pontos do símbolo | 0,55 s + 0,12 s por ponto | 0,5 s | Surgem de escala 0 → 1 com efeito mola |
| Avião do símbolo | 0,95 s | 0,8 s | Entra de (−18 px, +18 px) girado −8° até a posição final |
| Logotipo | 1,35 s | 0,7 s | Sobe de baixo (máscara) |
| Frase | 1,7 s | 0,7 s | Aparece subindo 8 px |
| Barra | 0,2 s | 2,3 s | Preenche 0 → 100% (`cubic-bezier(.4,0,.2,1)`) |
| Saída | 2,7 s | 0,55 s | Bloco central some e cresce para escala 1,08 |

A troca para a próxima tela é um esmaecimento cruzado de 320 ms.

## A DEFINIR
- Comportamento quando o carregamento real demora mais que 2,7 s (manter a abertura? mostrar erro?).
- Comportamento offline na abertura.

Estados desta fatia:

- Vazio: o que `00-abertura.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado o app fechado e sem sessão, quando ele abre, então a abertura ocupa a tela por 2,7 s e esmaece em 320 ms para o login; verificado por teste de widget com relógio falso e inspeção no frame 390×844.
- [ ] **AC-2** — Dado sessão mocada ativa, quando a abertura termina, então o app vai ao Início sem passar pelo login; verificado por teste de widget.
- [ ] **AC-3** — Dado a abertura visível, quando o usuário toca a tela, então nada navega nem muda; verificado por teste de widget.
- [ ] **AC-4** — Dado a abertura, quando os elementos entram, então o traço, os pontos, o avião, o logotipo, a frase e a barra seguem os instantes e as durações de BUSINESS/00-abertura.md, com a palavra “inteira” em itálico e lima; verificado por inspeção lado a lado com o protótipo.
- [ ] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `00-abertura.md`; verificado por inspeção lado a lado.
- [ ] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; verificado por inspeção.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `00-abertura.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| 5. Sessão “ativa” é criada ao entrar com Google/e-mail, ao concluir o cadastro ou ao criar conta a partir do modo convidado; é apagada ao sair (`28-perfil.md`). Expiração da sessão por tempo: `A DEFINIR`. | não | produto | antes do refine-spec |
| ## A DEFINIR | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `abertura` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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
