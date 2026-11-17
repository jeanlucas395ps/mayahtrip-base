# Explorar como convidado

- Slug: `modo-convidado`
- Status: `concluída` — modo convidado no app, testado em 2026-11-17 (`mayahtrip-app`); a inspeção lado a lado com o protótipo (AC-6) não foi feita nesta entrega
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/04-modo-convidado.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `inicio`, `explorar`, `pagina-do-lugar`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `04-modo-convidado.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Entrada sem conta e as barreiras nas telas que já existem. Criar conta pela folha, no protótipo, cria a sessão mocada e executa a ação pendente.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `04-modo-convidado.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Entrada sem conta e as barreiras nas telas que já existem. Criar conta pela folha, no protótipo, cria a sessão mocada e executa a ação pendente.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Entrada sem conta e as barreiras nas telas que já existem. Criar conta pela folha, no protótipo, cria a sessão mocada e executa a ação pendente.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Objetivo
Deixar a pessoa conhecer o app sem criar conta e convidá-la a criar conta no momento em que tentar algo que exige identificação.

## Entrada
Login → “Explorar como convidado” (indicador giratório por 900 ms) → Início, com o aviso “Explorando como convidado”.

## O que muda no app
| Área | Comportamento |
| --- | --- |
| Início | Faixa no topo: fundo `#15122E`, raio 18 px, “Você está como convidado” (13 px/700 branco) / “Crie sua conta para salvar viagens e gastos” (12 px `#C9C6DA`) + botão lima “Criar conta” (34 px). Avatar vira círculo cinza `#E9E7F0` com ícone de pessoa; saudação “{Bom dia…}, viajante”. Sem “Sua próxima viagem”. |
| Carteira | Vazia (estado “Nenhuma viagem ainda”). |
| Notificações | Só a de boas-vindas. Sem contador de não lidas além dela. |
| Perfil | Tocar em Perfil abre o convite para criar conta. |

## Ações que pedem conta
Ao tentar qualquer item abaixo, abre a folha **“Crie sua conta para {motivo}”**:

| Ação | Motivo exibido |
| --- | --- |
| Seguir viajante | seguir viajantes |
| Criar viagem (botão final do assistente) | criar sua viagem |
| Novo gasto (ações rápidas) | lançar gastos |
| Adicionar parada (ações rápidas) | montar seu roteiro |
| Inserir lugar no roteiro | salvar no seu roteiro |
| Salvar lugar | salvar lugares |
| Publicar vídeo/review | publicar reviews |
| Curtir | curtir e seguir viajantes |
| Avaliar parada | avaliar paradas |
| Comentar | comentar |
| Abrir Perfil | ter seu perfil |
| Faixa do Início | salvar suas viagens |

## Folha “Crie sua conta”
- Centralizada: símbolo 34 px + logotipo `#15122E` 120 px.
- Título editorial 34 px “Crie sua conta para {motivo}”.
- Texto 13 px (máx. 290 px): “É grátis e leva 10 segundos. Tudo que você explorou continua aqui.”
- **Continuar com Google** · **Criar com e-mail** (primário) · link **Continuar explorando** (fecha).

## Regras de negócio
1. Ao criar conta pela folha, a sessão é criada, o aviso “Conta criada. Bem-vindo, {nome}!” aparece e **a ação que estava pendente é executada automaticamente** 350 ms depois (ex.: o lugar é salvo).
2. Como salvar e curtir já exigem conta, o convidado não acumula dados; a frase “Tudo que você explorou continua aqui” se refere à tela em que ele estava, que é mantida. Persistência de qualquer dado do convidado após fechar o app: `A DEFINIR`.
3. “Criar com e-mail” na folha leva direto ao cadastro? No protótipo cria a conta direto. Fluxo real: `A DEFINIR` (sugestão: abrir `02-cadastro-e-verificacao.md` e voltar à ação pendente).

Estados desta fatia:

- Vazio: o que `04-modo-convidado.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado o login, quando a pessoa toca Explorar como convidado, então após 900 ms o Início abre com o aviso “Explorando como convidado” e a faixa #15122E; verificado por teste de widget.
- [ ] **AC-2** — Dado o convidado no Início, quando a tela abre, então não há “Sua próxima viagem”, a saudação é “viajante” e o avatar é o círculo cinza; a carteira mostra “Nenhuma viagem ainda”; verificado por teste de widget.
- [ ] **AC-3** — Dado o convidado, quando ele toca Perfil, então a folha pede conta para “ter seu perfil” e não abre o perfil; verificado por teste de widget.
- [ ] **AC-4** — Dado uma ação da tabela de BUSINESS/04, quando o convidado a dispara, então a folha usa o motivo daquela linha e Continuar explorando fecha sem executar; verificado por teste de widget.
- [ ] **AC-5** — Dado a folha aberta por uma ação pendente, quando a conta mocada é criada, então 350 ms depois a ação pendente acontece e o aviso diz “Conta criada. Bem-vindo, {nome}!”; verificado por teste de widget com relógio falso.
- [ ] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `04-modo-convidado.md`; verificado por inspeção lado a lado.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; verificado por inspeção.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `04-modo-convidado.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| 2. Como salvar e curtir já exigem conta, o convidado não acumula dados; a frase “Tudo que você explorou continua aqui” se refere à tela em que ele estava, que é mantida. Persistência de qualquer dado do convidado após fechar o app: `A DEFINIR`. | não | produto | antes do refine-spec |
| 3. “Criar com e-mail” na folha leva direto ao cadastro? No protótipo cria a conta direto. Fluxo real: `A DEFINIR` (sugestão: abrir `02-cadastro-e-verificacao.md` e voltar à ação pendente). | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `modo-convidado` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `inicio` em `007-inicio.md`
- `explorar` em `011-explorar.md`
- `pagina-do-lugar` em `010-pagina-do-lugar.md`
