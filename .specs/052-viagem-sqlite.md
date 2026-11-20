# Gravar a viagem criada no SQLite

- Slug: `viagem-sqlite`
- Status: `em execução` — SQLite real (`sqflite`) e checagem de rede real (`connectivity_plus`) implementados e testados em 2026-11-18 (`mayahtrip-app`); specs irmãs (`ver-viagem-offline`, `despesa-offline`, `rota-offline`, `arquivo-offline`, `parada-feita-offline`, `link-offline`, `mala-offline`, `review-offline`, `listagem-viagens-offline`) ficaram pendentes nesta entrega
- Data: 2026-11-17
- Última atualização: 2026-11-18
- Responsável: a definir no refine-spec
- Repositório: `mayahtrip-app`
- Docs relacionados: `BUSINESS/14-nova-viagem.md`, `BUSINESS/BUSINESS.md` §4.4, `ARCHITECTURE.md` §4
- Specs relacionadas: `nova-viagem`, `ver-viagem-offline`, `despesa-offline`, `rota-offline`, `arquivo-offline`, `parada-feita-offline`, `link-offline`, `mala-offline`, `review-offline`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: criar uma viagem usa cidades, lugares e, quando cabe, um roteiro sugerido ou da comunidade (`BUSINESS/14`). Essas listagens vêm da API. Sem rede, a criação não tem o que mostrar.

Fato: o documento da viagem já é pensado para abrir sem internet (`BUSINESS/25`). O restante da viagem criada hoje não tem um contrato de cópia local.

Quem sente: a pessoa que criou a viagem e depois fica sem rede. Sem uma cópia local, ela não consegue atualizar o que já é dela.

Premissa: a cópia local mora no SQLite do aparelho. Esta fatia só grava a viagem no momento em que a criação online termina. Não descreve cada edição offline.

## 2. Necessidade de negócio

A viagem precisa existir no aparelho depois de criada, para as fatias offline seguintes terem o que ler e atualizar. O sucesso é: com rede, criar grava no SQLite; sem rede, criar não começa.

## 3. Objetivo e resultado observável

Depois de “Criar viagem” com rede, a viagem, os destinos e os lugares já recebidos nessa criação estão no SQLite e continuam lá depois de fechar e abrir o app. Sem rede, o app não cria viagem e não grava linha nova.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Dono da conta, com rede | Concluir a criação e ter a viagem gravada no aparelho | A criação segue `nova-viagem` |
| Dono da conta, sem rede | Ver que não dá para criar agora | Nenhuma viagem nova é gravada |
| Convidado | Nada nesta fatia | Criar viagem pede conta (`BUSINESS/04`) |

## 5. Escopo

### 5.1 Dentro do escopo

- Criar viagem só com rede, porque a listagem de destinos e de lugares vem da API.
- Ao sucesso da criação, gravar no SQLite a viagem, os destinos escolhidos e os lugares já trazidos nessa resposta.
- A viagem continua lá depois de encerrar e reabrir o app, ainda sem rede.
- Sem rede no instante de criar, a criação não conclui e o SQLite não ganha viagem nova.
- Falha da API no meio da criação não deixa viagem pela metade no SQLite.

### 5.2 Fora de escopo

- `ver-viagem-offline`, `despesa-offline`, `rota-offline`, `arquivo-offline`, `parada-feita-offline`, `link-offline`, `mala-offline`, `review-offline`.
- Redesenhar os quatro passos de `nova-viagem`.
- Enviar de volta à API, mais tarde, o que foi editado offline. Como e quando sincronizar: pergunta não bloqueante.
- Apagar a cópia local, conflito entre dois aparelhos e backup do SQLite.

## 6. Comportamento esperado

1. Com rede, a pessoa termina `nova-viagem`. A API devolve a viagem criada, com destinos e lugares daquela criação.
2. O app grava essa resposta no SQLite na mesma conclusão. Se a gravação local falha, a pessoa vê erro e a criação não aparece como pronta no aparelho.
3. Fechar e abrir o app, com ou sem rede, ainda encontra essa viagem no SQLite.
4. Sem rede ao tocar em criar, o app não chama a criação e não insere viagem. A pessoa vê que precisa de internet para criar, porque a listagem e os lugares não estão disponíveis.
5. Convidado continua sem criar viagem.

Estados: sem rede antes de criar; criação recusada pela API; criação aceita e cópia local gravada; criação aceita e cópia local falhou.

## 7. Critérios de aceite

- [x] **AC-1** — Dado conta com sessão e rede, quando a criação da viagem termina com sucesso, então a viagem, os destinos e os lugares recebidos nessa resposta existem no SQLite; verificado por teste de integração com banco local de teste (`viagens_offline_repository_test.dart`, arquivo SQLite real via `sqflite_common_ffi`).
- [x] **AC-2** — Dado AC-1 já gravado, quando o app é encerrado e aberto de novo sem rede, então essa mesma viagem ainda é lida do SQLite; verificado por teste de integração reabrindo o banco (`viagens_offline_repository_test.dart` — fecha o `BancoLocal`, abre um novo apontando pro mesmo arquivo, lê de novo).
- [x] **AC-3** — Dado conta com sessão e sem rede, quando a pessoa tenta criar a viagem, então nenhuma linha nova entra no SQLite e a tela informa que criar precisa de internet; verificado por teste de widget com rede desligada (`nova_viagem_wizard_test.dart`).
- [x] **AC-4** — Dado a API recusou ou caiu no meio da criação, quando o app trata a falha, então o SQLite não fica com viagem incompleta dessa tentativa; verificado por teste de integração com resposta de erro (`viagens_offline_repository_test.dart` — D-4: sem API real nesta base de código, a falha simulada é uma violação de chave primária no meio da transação, provando o rollback).
- [x] **AC-5** — Dado modo convidado, quando a pessoa tenta criar viagem, então nada é gravado no SQLite; verificado por teste de widget (`nova_viagem_wizard_test.dart`).

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | A cópia local da viagem fica no SQLite do aparelho. Criar viagem exige rede, porque destinos e lugares vêm da API. As edições offline são as specs irmãs, não esta. | pedido de 2026-11-17 | As irmãs citam esta spec e não escolhem outro banco |
| P-1 | premissa | “Lugares já trazidos nessa resposta” são os que a criação devolveu. Busca nova de lugar continua online e não entra aqui. | produto | Conferir na implementação de `nova-viagem` qual payload a criação devolve |
| P-2 | premissa | O texto exato do aviso sem rede usa os quatro idiomas da interface. A frase não está no protótipo. | produto | `refine-spec` confere o texto com `gen_l10n` |
| D-4 | decisão | `nova-viagem` nunca chamou API real (é mocada, igual a toda a base de código até aqui) — não existe uma "criação online" de verdade pra falhar no meio. AC-4 foi verificado forçando uma violação de chave (dois lugares com o mesmo id) dentro da mesma transação SQLite que grava a viagem, provando que o `rollback` do `sqflite` não deixa linha incompleta — não uma resposta de erro de API de verdade. | app | revisão desta spec |
| D-5 | decisão | Texto do aviso sem rede implementado como "Criar viagem precisa de internet." (P-2 continua aberta — não é o texto final nem está nos 4 idiomas; só prova o comportamento do AC-3). | app | `refine-spec` com `gen_l10n` |
| D-6 | decisão | Esquema SQLite criado em `BancoLocal` já inclui `dias_roteiro`, `paradas_roteiro` e `rotas` (tabelas que esta spec não usa, mas que `057-parada-feita-offline.md` e `055-rota-offline.md` vão precisar) — para não forçar uma migração de esquema quando essas specs irmãs forem implementadas. Essas tabelas ficam vazias nesta entrega. | app | `055`/`057` quando forem implementadas |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | O app passa a guardar a viagem criada no SQLite, além do que a API devolveu. O app continua sem chamar Google, Asaas ou OpenAI. |
| Dados                  | Banco local no aparelho. A fonte durável do servidor continua o Postgres, quando a criação online existir. |
| UI/UX e acessibilidade | Um aviso quando criar sem rede. O assistente de quatro passos não muda de layout. |
| Segurança              | A cópia local é da conta que criou. Convidado não grava. Log sem documento nem token. |
| Observabilidade        | A criação online propaga correlation id até a API. A falha de gravar o SQLite entra no log sem o conteúdo da viagem. |

## 10. Plano de testes

- Widget/unitário: AC-3 e AC-5, com rede simulada desligada e modo convidado.
- Integração: AC-1, AC-2 e AC-4, com SQLite de teste.
- Manual no frame 390×844: criar com rede, reabrir sem rede e ver a viagem ainda listada; tentar criar sem rede.
- Casos de borda: API falha depois de a pessoa tocar em criar; gravar no SQLite falha depois do sucesso da API.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| Viagem criada na API e não gravada no aparelho | média | alto | AC-4 e o erro visível; a pessoa não vê viagem “pronta” só no servidor sem cópia local |
| Banco local cresce sem limite | baixa | médio | Fora desta fatia; não apagar dado para “resolver” |

- Rollback: deixar de escrever no SQLite e voltar a manter a viagem só em memória. As specs irmãs ficam sem base e não devem ser usadas nesse rollback.
- Critério para abortar: se criar com rede não puder devolver destinos e lugares, esta fatia não tem o que gravar. Pare e não invente listagem local.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Quando a edição feita offline sobe para a API, e o que acontece se o servidor também mudou | não | produto | antes de implementar sincronização; não bloqueia gravar a criação |
| A cópia local é cifrada no aparelho | não | produto | — |
| Texto final do aviso “criar precisa de internet” | não | produto | no refine-spec, nos quatro idiomas |

## 13. Resultado

Pronto quando criar com rede deixa a viagem no SQLite depois de reabrir o app, e criar sem rede não grava nada.

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

- `nova-viagem` em `016-nova-viagem.md`
