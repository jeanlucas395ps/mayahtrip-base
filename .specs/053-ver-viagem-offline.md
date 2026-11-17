# Ver a viagem já salva sem rede

- Slug: `ver-viagem-offline`
- Status: `rascunho`
- Data: 2026-11-17
- Última atualização: 2026-11-17
- Responsável: a definir no refine-spec
- Repositório: `mayahtrip-app`
- Docs relacionados: `BUSINESS/16-viagem-capa-e-abas.md`, `BUSINESS/15-carteira-de-viagens.md`, `ARCHITECTURE.md` §5
- Specs relacionadas: `viagem-sqlite`, `listagem-viagens-offline`, `rota-offline`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: `viagem-sqlite` grava no aparelho a viagem criada online, com os lugares que aquela criação trouxe.

Quem sente: a pessoa que já tem a viagem no aparelho e abre o app sem internet. Ela precisa ver o que já foi salvo, inclusive a imagem que já estava no aparelho.

Premissa: “imagem” aqui é a mídia já gravada junto com a viagem (capa e fotos de lugar que a criação trouxe). Não é busca nova de imagem.

## 2. Necessidade de negócio

Sem leitura offline, o SQLite não serve para quem está sem rede. O sucesso é abrir a viagem salva e ver os dados e as imagens já presentes, com a rede desligada.

## 3. Objetivo e resultado observável

Com a viagem no SQLite e sem rede, a carteira e a capa mostram essa viagem, os destinos, os lugares já salvos e as imagens já salvas. Nada novo é baixado.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| ------------- | ---------------- | ---------- |
| Dono, supremo, experiente e júnior, com a viagem no aparelho | Ver a viagem, os lugares já salvos e as imagens já salvas | Júnior não vê gastos nem documentos; experiente não vê documentos (`BUSINESS.md` §4.3) |
| Quem não tem a viagem no SQLite | Não vê essa viagem | Esta fatia não baixa a viagem de outro aparelho |

## 5. Escopo

### 5.1 Dentro do escopo

- Ler do SQLite, sem rede, a viagem gravada por `viagem-sqlite`.
- Mostrar capa, destinos, lugares já salvos e imagens já salvas com esses registros.
- Se a imagem não foi salva junto, o lugar aparece sem essa imagem, no bloco vazio que o protótipo já usa quando não há foto.
- A lista de várias viagens, com filtros e ordenação, é `listagem-viagens-offline`. Esta fatia começa com a viagem já aberta.

### 5.2 Fora de escopo

- `listagem-viagens-offline`, `despesa-offline`, `rota-offline`, `arquivo-offline`, `parada-feita-offline`, `link-offline`, `mala-offline`, `review-offline`.
- Baixar imagem, lugar ou listagem novos sem rede.
- Sincronizar edição com a API. Pergunta não bloqueante de `viagem-sqlite`.

## 6. Comportamento esperado

1. Sem rede, a pessoa abre uma viagem que já está no SQLite. A lista que levou até ela é `listagem-viagens-offline`.
2. A capa mostra título, datas ou duração, destinos e a imagem de capa se ela estiver no aparelho.
3. Lugares já salvos aparecem com o nome guardado. A foto aparece só se o arquivo já estiver no aparelho.
4. Lugar sem foto salva usa o estado sem foto. O app não tenta a rede para completar.
5. Viagem ausente do SQLite não aparece.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado uma viagem no SQLite com capa e foto de lugar já salvas, quando essa viagem é aberta sem rede, então a capa mostra esses textos e essas imagens; verificado por teste de integração com banco e arquivos locais de teste.
- [ ] **AC-2** — Dado a mesma viagem sem o arquivo de imagem, quando a capa ou o lugar abre sem rede, então o texto salvo aparece e a imagem fica no estado vazio, sem pedido de rede; verificado por teste de widget com rede desligada.
- [ ] **AC-3** — Dado o identificador de uma viagem que não está no SQLite, quando a capa é pedida sem rede, então a viagem não é criada e a tela não baixa dado; verificado por teste de integração.
- [ ] **AC-4** — Dado júnior nessa viagem, quando ele abre a capa sem rede, então vê o roteiro salvo e não vê gastos nem documentos; verificado por teste de widget.

## 8. Premissas e decisões

| ID  | Tipo     | Descrição | Dono | Validação |
| --- | -------- | --------- | ---- | --------- |
| D-1 | decisão  | Ver offline só o que já está no SQLite e nos arquivos locais. Imagem que não foi salva não é buscada sem rede. | pedido de 2026-11-17 | AC-2 |
| P-1 | premissa | A capa e a carteira reutilizam o layout de `viagem-capa` e `carteira`. Esta fatia troca a fonte do dado, não o desenho. | produto | Inspeção no frame 390×844 no refine-spec |

## 9. Impactos

| Área                   | Impacto |
| ---------------------- | ------- |
| Arquitetura/contratos  | Leitura da viagem passa a poder vir do SQLite quando não há rede. |
| Dados                  | Só leitura nesta fatia. |
| UI/UX e acessibilidade | Estado sem foto já previsto no protótipo. Sem tela nova. |
| Segurança              | Não mostrar gasto nem documento a quem o papel não deixa. |
| Observabilidade        | Falha ao ler o banco entra no log sem conteúdo da viagem. |

## 10. Plano de testes

- Widget/unitário: AC-2, AC-3 e AC-4.
- Integração: AC-1, com SQLite e arquivo de imagem de teste.
- Manual no frame 390×844: abrir a viagem salva em modo avião.
- Casos de borda: imagem registrada no banco e arquivo ausente no disco.

## 11. Riscos e rollback

| Risco | Probabilidade | Impacto | Mitigação |
| ----- | ------------- | ------- | --------- |
| App tenta a rede ao abrir a capa e parece travado | média | alto | AC-2: sem pedido de rede para completar imagem |

- Rollback: voltar a ler só da memória da sessão. A viagem deixa de aparecer depois de reabrir sem rede.
- Critério para abortar: se `viagem-sqlite` não gravar a viagem, não há o que ler. Não invente cache paralelo.

## 12. Perguntas em aberto

| Pergunta | Bloqueante? | Dono | Prazo |
| -------- | ----------- | ---- | ----- |
| Quais imagens, além da capa e da foto do lugar trazidas na criação, entram na cópia local | não | produto | — |
| Sincronizar o que foi visto ou alterado quando a rede voltar | não | produto | não bloqueia esta leitura |

## 13. Resultado

Pronto quando, sem rede, a pessoa vê a viagem já salva, com as imagens que já estavam no aparelho e sem imagem nova sendo baixada.

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
