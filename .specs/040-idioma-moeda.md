# Idioma e moeda

- Slug: `idioma-moeda`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/35-idioma-e-moeda.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `perfil`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `35-idioma-e-moeda.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Folha Idioma e moeda e o efeito nos valores já exibidos. Não cria locale além dos quatro.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `35-idioma-e-moeda.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Folha Idioma e moeda e o efeito nos valores já exibidos. Não cria locale além dos quatro.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Folha Idioma e moeda e o efeito nos valores já exibidos. Não cria locale além dos quatro.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Regra principal
- **Idioma e moeda padrão vêm do lugar onde o usuário está.**
- A opção padrão, enquanto o usuário não escolhe nada, é **“Minha localização”** para os dois.
- Se o usuário escolher um idioma ou moeda, **a escolha do perfil sempre é respeitada**, mesmo que ele mude de país.
- Referência do protótipo: usuário em Lisboa, Portugal → Português (Portugal) e Euro (€).

## Acesso
Perfil → Configurações → **Idioma e moeda** (à direita: “Minha localização” ou “Personalizado”).

## Folha alta
- Cabeçalho “Idioma e moeda” / “Por padrão usamos sua localização: {cidade}, {país}”.
- **IDIOMA** (cartão, fundo da tela): Minha localização (“{idioma da localização}”) e, em seguida, só estes quatro: Português (Brasil), Português (Portugal), English, Español. Seleção com marcador redondo 24 px.
- **MOEDA DE EXIBIÇÃO**: Minha localização (“{moeda local}”) · Euro (€) · Real (R$) · Dólar (US$) · Libra (£).
- Nota 12 px: “Fusos horários são mostrados em relação à sua localização. Gastos em outras moedas são convertidos pelo câmbio do dia.”
- Avisos: “Idioma: minha localização” / “Idioma atualizado”; “Valores exibidos em {moeda}”.

## Efeitos no app
1. Todos os valores (gastos, orçamento, preços de lugares, lista de compras, notificações de gasto) são exibidos na moeda de exibição, convertidos pelo câmbio do dia.
2. Novo gasto e lista de compras começam na moeda de exibição.
3. Fuso nas informações da viagem é relativo à localização atual (“+1h”, “Mesmo horário de Lisboa (sua localização)”).
4. O formato numérico segue o idioma da interface e a moeda de exibição.
   - Português (Brasil) e Português (Portugal): milhar “.”, decimal “,” (1.234,56).
   - English: milhar “,”, decimal “.” (1,234.56).
   - Español: milhar “.”, decimal “,” (1.234,56).

## Idiomas da interface

A interface inteira (app, API nas mensagens ao usuário e painel) existe só nestes quatro idiomas. Não há outro locale.

| Idioma | Código | “Minha localização” quando o país é |
| --- | --- | --- |
| Português (Brasil) | `pt-BR` | Brasil. Também é o idioma quando a localização não está disponível |
| Português (Portugal) | `pt-PT` | Portugal |
| English | `en` | EUA, Reino Unido, Canadá, Austrália |
| Español | `es` | Espanha, México, Argentina, Colômbia |

“Minha localização” escolhe um destes quatro. País que não está na tabela usa Português (Brasil). A escolha explícita no perfil substitui a localização e também é um destes quatro.

Sem permissão de localização: idioma Português (Brasil) e moeda Real (R$).

E-mail transacional (verificação, senha, convite) sai no idioma da interface de quem recebe. Se essa pessoa ainda não tem conta, o e-mail usa o idioma de quem enviou. A Maya responde no mesmo idioma da interface ativa. Nenhum desses textos existe fora dos quatro idiomas.

Câmbio do dia: `api.frankfurter.dev`.

## Moedas de exibição

| Moeda | Código |
| --- | --- |
| Real brasileiro | BRL (padrão, junto com Português (Brasil), quando não há localização) |
| Dólar americano | USD |
| Libra esterlina | GBP |
| Dólar canadense | CAD |
| Dólar australiano | AUD |
| Euro | EUR |
| Peso mexicano | MXN |
| Franco suíço | CHF |
| Yuan chinês | CNY |
| Iene japonês | JPY |

Estados desta fatia:

- Vazio: o que `35-idioma-e-moeda.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado a folha, quando ela abre sem escolha prévia, então Idioma e Moeda estão em Minha localização e a lista de idiomas tem só Português (Brasil), Português (Portugal), English e Español; verificado por inspeção.
- [ ] **AC-2** — Dado uma escolha explícita, quando a localização do aparelho muda, então a escolha do perfil permanece; verificado por teste de widget.
- [ ] **AC-3** — Dado país fora da tabela ou localização indisponível, quando a opção é Minha localização, então o idioma é pt-BR; verificado por teste de widget.
- [ ] **AC-4** — Dado pt-BR, pt-PT ou es, quando um valor é exibido, então o formato é 1.234,56; dado en, então 1,234.56; verificado por teste de widget.
- [ ] **AC-5** — Dado a moeda de exibição, quando um gasto foi lançado em outra moeda, então a tela mostra o valor convertido e o lançamento guarda a moeda original; verificado por teste de widget.
- [ ] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `35-idioma-e-moeda.md`; verificado por inspeção lado a lado.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; verificado por inspeção.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `35-idioma-e-moeda.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| Nenhuma nesta fatia. | não | — | — |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `idioma-moeda` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `perfil` em `030-perfil.md`
