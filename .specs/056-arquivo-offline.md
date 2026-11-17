# Guardar arquivo da viagem sem rede

- Slug: `arquivo-offline`
- Status: `rascunho`
- Data: 2026-11-17
- Última atualização: 2026-11-17
- Responsável: a definir no refine-spec
- Repositório: `mayahtrip-app`
- Docs relacionados: `BUSINESS/25-documentos-e-links.md`, `ARCHITECTURE.md` §3
- Specs relacionadas: `viagem-sqlite`, `documentos-links`, `link-offline`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: todo documento da viagem fica disponível offline, e só dono e viajante supremo veem a aba Docs (`BUSINESS/25`). O arquivo binário de produção mora no Google Cloud Storage, chamado pela API.

Quem sente: quem está sem rede e precisa anexar a foto ou o PDF da reserva na hora.

Premissa: “upload” sem rede significa guardar o arquivo no aparelho, ligado à viagem no SQLite, e poder abri-lo depois sem internet. Enviar o arquivo à API não faz parte desta fatia. Limite de tamanho e tipos aceitos continuam `A DEFINIR` em `BUSINESS/25`.

## 2. Necessidade de negócio

O documento já promete uso sem internet. Falta poder acrescentar um arquivo quando a rede não existe. O sucesso é o arquivo abrir depois de reabrir o app, ainda sem rede.

## 3. Objetivo e resultado observável

Dono ou supremo, sem rede, adicionam um arquivo à viagem salva. O item entra na lista com a etiqueta Offline e abre no aparelho depois de fechar e abrir o app. Experiente e júnior não veem a aba.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Dono e viajante supremo | Acrescentar e abrir o arquivo offline | Tipos e tamanho máximo seguem `A DEFINIR`; o teste usa um arquivo pequeno já aceito pela folha atual (foto ou PDF) |
| Viajante experiente e assistente júnior | Não veem documentos | Não gravam arquivo |
| Convidado | Nada | Sem viagem |

## 5. Escopo

### 5.1 Dentro do escopo

- Sem rede, escolher um arquivo já existente no aparelho ou uma foto recém-capturada e associá-lo à viagem no SQLite.
- O arquivo fica no armazenamento local do app e abre sem rede.
- A lista mostra o aviso já previsto: salvo e disponível offline.
- Falha ao copiar o arquivo para o app não cria item na lista.

### 5.2 Fora de escopo

- `link-offline`, `despesa-offline`, `mala-offline`, `review-offline`, `parada-feita-offline`, `rota-offline`.
- Enviar o arquivo ao Google Cloud Storage ou à API. Pergunta não bloqueante.
- Excluir documento, OCR e “Meus documentos” do perfil, que seguem `A DEFINIR` em `BUSINESS/25`.
- Inventar limite de tamanho ou lista de mime types.

## 6. Comportamento esperado

1. Sem rede, dono ou supremo abrem Docs da viagem que está no SQLite.
2. Adicionam uma foto ou um PDF. O app copia o arquivo para a área local e grava o metadado no SQLite.
3. A lista mostra o item no topo, com a etiqueta Offline, e o aviso “Salvo e disponível offline”.
4. Toque abre o arquivo sem rede. Reabrir o app, ainda sem rede, mantém o item e o arquivo.
5. Se a cópia falha, a lista não ganha item e a pessoa vê erro.
6. Experiente e júnior não entram em Docs.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado dono ou supremo, viagem no SQLite e sem rede, quando adiciona uma foto ou um PDF, então o metadado está no SQLite e o arquivo abre a partir do armazenamento local; verificado por teste de integração.
- [ ] **AC-2** — Dado AC-1, quando o app reabre sem rede, então o mesmo item continua na lista e o arquivo ainda abre; verificado por teste de integração.
- [ ] **AC-3** — Dado a cópia do arquivo falha, quando o app trata o erro, então a lista não ganha item; verificado por teste de integração.
- [ ] **AC-4** — Dado experiente ou júnior, quando abrem a viagem sem rede, então a aba Docs não aparece e nenhum arquivo é gravado; verificado por teste de widget.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | Arquivo acrescentado sem rede fica no aparelho e abre offline. O envio ao servidor não é requisito desta fatia. | pedido de 2026-11-17 | AC-1 e AC-2 |
| P-1 | premissa | A folha de adicionar documento é a de `BUSINESS/25`: tirar foto ou escolher arquivo. Colar link é `link-offline`. | produto | Não misturar as duas specs |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | O binário fica no aparelho até existir a fatia que envia à API. O app não chama o storage direto. |
| Dados                  | Metadado no SQLite e arquivo na área local do app. |
| UI/UX e acessibilidade | Reusa a aba Docs e o aviso já escrito em `BUSINESS/25`. |
| Segurança              | Experiente e júnior não leem o arquivo. Log sem nome de documento nem conteúdo. |
| Observabilidade        | Falha de cópia entra no log sem o arquivo. |

## 10. Plano de testes

- Widget/unitário: AC-4.
- Integração: AC-1, AC-2 e AC-3, com arquivo temporário e SQLite de teste.
- Manual no frame 390×844: em modo avião, adicionar uma foto e abrir de novo o app.
- Casos de borda: usuário cancela a escolha do arquivo; nada é gravado.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| Arquivo só no aparelho e perdido na troca de celular | média | alto | Envio ao servidor ficou explícito fora desta fatia |

- Rollback: adicionar documento volta a exigir rede. Arquivos já copiados localmente não são apagados por esse rollback.
- Critério para abortar: se o papel que vê Docs mudar em `BUSINESS/25`, pare.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Quando o arquivo local é enviado à API e ao Google Cloud Storage | não | produto | não bloqueia guardar e abrir no aparelho |
| Limite de tamanho e tipos aceitos | não | produto | continua `A DEFINIR` em `BUSINESS/25` |
| Excluir documento | não | produto | continua `A DEFINIR` |

## 13. Resultado

Pronto quando um arquivo acrescentado sem rede abre de novo depois de reabrir o app, e quem não pode ver Docs não o grava.

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

- `viagem-sqlite` em `052-viagem-sqlite.md`
