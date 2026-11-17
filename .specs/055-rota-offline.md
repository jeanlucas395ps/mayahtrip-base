# Ver a rota já salva sem rede

- Slug: `rota-offline`
- Status: `rascunho`
- Data: 2026-11-17
- Última atualização: 2026-11-17
- Responsável: a definir no refine-spec
- Repositório: `mayahtrip-app`
- Docs relacionados: `BUSINESS/17-roteiro-lista.md`, `BUSINESS/18-roteiro-mapa.md`, `ARCHITECTURE.md` §3
- Specs relacionadas: `viagem-sqlite`, `ver-viagem-offline`, `roteiro-lista`, `roteiro-mapa`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o deslocamento entre paradas tem modo, distância e duração. A API é quem consulta Google Directions e Distance Matrix (`ARCHITECTURE.md`). O app não chama o Google.

Quem sente: a pessoa que já gerou ou abriu o roteiro com rede e depois quer olhar a rota sem internet.

Premissa: “ver rotas” offline é ler o deslocamento já gravado no SQLite. Não é calcular uma rota nova sem rede.

## 2. Necessidade de negócio

A rota que já foi obtida na criação ou numa abertura online precisa continuar visível sem rede. O sucesso é a lista e o mapa mostrarem esse deslocamento salvo, e não pedirem cálculo novo.

## 3. Objetivo e resultado observável

Sem rede, o roteiro da viagem salva mostra os deslocamentos que já estão no SQLite. Um trecho que nunca foi calculado aparece sem distância nova. O app não dispara cálculo.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Dono, supremo, experiente e júnior | Ver o deslocamento já salvo | Júnior não edita o roteiro |
| Qualquer um desses papéis | Não recalcula a rota sem rede | Cálculo novo exige a API, portanto rede |

## 5. Escopo

### 5.1 Dentro do escopo

- Ler do SQLite o deslocamento já associado às paradas da viagem.
- Mostrar esse deslocamento na lista e no mapa, sem rede.
- Trecho sem deslocamento salvo permanece sem distância e sem duração inventadas.
- Tentar otimizar ou recalcular sem rede não altera o SQLite e informa que essa ação precisa de internet.

### 5.2 Fora de escopo

- `despesa-offline`, `arquivo-offline`, `parada-feita-offline`, `link-offline`, `mala-offline`, `review-offline`.
- Calcular rota offline, desenhar geometria que não foi salva, ou chamar Google no app.
- Sincronizar mudança de rota com a API.

## 6. Comportamento esperado

1. Sem rede, a pessoa abre o roteiro da viagem que está no SQLite.
2. Entre duas paradas que já têm deslocamento salvo, a lista mostra modo, distância e duração guardados. O mapa mostra a geometria se ela também foi salva.
3. Sem geometria salva, o mapa não inventa a linha e não busca a rede.
4. Sem deslocamento salvo, o trecho fica sem esses números.
5. Ação de recalcular ou otimizar, sem rede, não grava nada e avisa que precisa de internet.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado um deslocamento já no SQLite, quando a lista do roteiro abre sem rede, então modo, distância e duração mostrados são os gravados; verificado por teste de integração.
- [ ] **AC-2** — Dado o mesmo deslocamento sem geometria salva, quando o mapa abre sem rede, então nenhuma linha nova é desenhada e não há chamada de rede; verificado por teste de widget com rede desligada.
- [ ] **AC-3** — Dado um trecho sem deslocamento, quando a lista abre sem rede, então distância e duração não aparecem preenchidas; verificado por teste de widget.
- [ ] **AC-4** — Dado sem rede, quando a pessoa pede para recalcular ou otimizar a rota, então o SQLite permanece igual e a tela informa que a ação precisa de internet; verificado por teste de integração.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | Ver rota offline usa só o deslocamento já persistido. Recalcular continua online. | pedido de 2026-11-17 | AC-4 |
| P-1 | premissa | O desenho da lista e do mapa segue `roteiro-lista` e `roteiro-mapa`. | produto | Frame 390×844 no refine-spec |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | Leitura local do deslocamento. Cálculo continua na API, com rede. |
| Dados                  | Só leitura do que já está no SQLite, mais a recusa de gravar um recálculo sem rede. |
| UI/UX e acessibilidade | Aviso quando a pessoa pede recálculo sem rede. |
| Segurança              | Não se aplica além do papel que já pode ver o roteiro. |
| Observabilidade        | A recusa por falta de rede não gera chamada externa. Log sem geometria. |

## 10. Plano de testes

- Widget/unitário: AC-2 e AC-3.
- Integração: AC-1 e AC-4.
- Manual no frame 390×844: abrir o mapa em modo avião com uma rota já salva e tentar otimizar.
- Casos de borda: geometria salva e corrompida não deve quebrar a lista; o mapa fica sem a linha.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| A pessoa acha que a rota offline foi atualizada pelo trânsito | média | médio | AC-4 deixa explícito que recalcular precisa de internet |

- Rollback: o mapa volta a depender de rede para mostrar qualquer rota.
- Critério para abortar: se o deslocamento nunca for gravado por `viagem-sqlite` nem por uma abertura online, não invente distância.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| A geometria da rota entra na gravação inicial ou só depois da primeira abertura online do mapa | não | produto | não bloqueia ler o que já estiver salvo |
| Sincronizar uma otimização feita depois, com rede | não | produto | — |

## 13. Resultado

Pronto quando a rota já salva aparece sem rede, e um recálculo sem rede não muda o que está no aparelho.

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
