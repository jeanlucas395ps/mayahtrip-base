# Confirmar a conta

- Slug: `confirm-account`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/02-cadastro-e-verificacao.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `sign-up`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `02-cadastro-e-verificacao.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Passo 2 e a tela Conta criada. O código mocado é 1234. O passo 1 não é reespecificado.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `02-cadastro-e-verificacao.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Passo 2 e a tela Conta criada. O código mocado é 1234. O passo 1 não é reespecificado.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Passo 2 e a tela Conta criada. O código mocado é 1234. O passo 1 não é reespecificado.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Passo 2 — Verificação
Título “Verifique seu e-mail”; subtítulo “Enviamos um código de 4 dígitos para **{e-mail}**.”; voltar → passo 1.

### Caixas do código
- 4 caixas de **62 × 70 px**, raio 18 px, borda 1,5 px `#E5E3EC`, número 30 px/800, espaço 10 px, centralizadas.
- Foco: borda `#2B207F` + halo 4 px `#EBE8FF`. Preenchida: borda roxa e sobe 2 px (mola).
- Aceita só dígitos; ao digitar, pula para a próxima; Backspace numa caixa vazia volta e apaga a anterior; colar 4 dígitos preenche tudo e valida.
- O teclado numérico abre automaticamente na 1ª caixa (450 ms após entrar).

### Regras
1. Validação automática ao completar os 4 dígitos.
2. Código correto → caixas ficam verdes (borda `#3A9A2E`, fundo `#EEFFC2`) e, após 450 ms, vai para **Conta criada**.
3. Código errado → caixas com borda `#D2462A`, tremor horizontal de ±8 px em 400 ms e mensagem: “Código incorreto. Você ainda tem N tentativas.” (singular quando N = 1).
4. **Limite de 5 tentativas.** Na 5ª falha: “Você errou 5 vezes. Por segurança, peça um novo código.”, caixas desativadas e botão **Reenviar código** vira botão primário (40 px).
5. **Reenviar**: liberado após **30 s** (texto “Reenviar código em 0:SS”, contagem a cada 1 s); depois mostra “Não recebeu?” + link **Reenviar código**. Reenviar zera as tentativas, desbloqueia as caixas, reinicia os 30 s e mostra o aviso “Novo código enviado para {e-mail}”.
6. Validade do código: **10 minutos** (texto exibido na recuperação de senha; no cadastro `A DEFINIR` se exibe o mesmo texto).
7. Começar a digitar apaga a mensagem de erro.

## Conta criada
- Ícone de check 34 px em bloco lima 72 × 72 px, raio 24 px, entrada com “pop” (mola, 500 ms).
- Título editorial 36 px “Conta criada!”; texto “E-mail confirmado. Bem-vindo ao MayahTrip, {nome}.”
- Botão **Começar a explorar** (ícone bússola) → cria sessão, abre o Início e mostra “Bem-vindo, {primeiro nome}!”.
- O nome do perfil passa a ser o nome digitado e o usuário (@) a parte do e-mail antes do “@”.

Estados desta fatia:

- Vazio: o que `02-cadastro-e-verificacao.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado o passo 2, quando a tela abre, então 4 caixas recebem foco numérico na primeira após 450 ms e o subtítulo mostra o e-mail do passo 1; verificado por teste de widget.
- [x] **AC-2** — Dado o código 1234, quando os 4 dígitos são preenchidos ou colados, então as caixas ficam verdes e, após 450 ms, abre Conta criada; verificado por teste de widget.
- [x] **AC-3** — Dado um código diferente de 1234, quando os 4 dígitos fecham, então as caixas tremem, a borda fica #D2462A e a mensagem conta as tentativas restantes, até a 5ª falha desativar as caixas; verificado por teste de widget.
- [x] **AC-4** — Dado o reenvio, quando se passam 30 s, então o link Reenviar zera tentativas, desbloqueia as caixas e mostra “Novo código enviado para {e-mail}”; verificado por teste de widget com relógio falso (`codigo_verificacao_box_test.dart`, componente compartilhado com `forgot-password`).
- [x] **AC-5** — Dado Conta criada, quando a pessoa toca Começar a explorar, então nasce a sessão, o nome do perfil é o nome digitado, o @ é a parte do e-mail antes do @ e o Início mostra “Bem-vindo, {primeiro nome}!”; verificado por teste de widget.
- [x] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `02-cadastro-e-verificacao.md`; verificado por inspeção lado a lado (ponto de controle visual feito junto com `forgot-password`/`reset-password`).
- [x] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; satisfeito por herança dos tokens de `abertura`/`sign-in` — esta fatia não introduz nova animação de longa duração.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `02-cadastro-e-verificacao.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| 6. Validade do código: **10 minutos** (texto exibido na recuperação de senha; no cadastro `A DEFINIR` se exibe o mesmo texto). | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `confirm-account` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `sign-up` em `003-sign-up.md`
