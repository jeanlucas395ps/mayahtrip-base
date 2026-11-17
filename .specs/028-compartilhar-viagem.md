# Convite e papéis

- Slug: `compartilhar-viagem`
- Status: `rascunho`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/26-compartilhar-viagem-e-papeis.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `viagem-capa`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `26-compartilhar-viagem-e-papeis.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Folha de compartilhar, papéis e visibilidade. Convite pendente, convite por link e transferir a posse ficam fora.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `26-compartilhar-viagem-e-papeis.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Folha de compartilhar, papéis e visibilidade. Convite pendente, convite por link e transferir a posse ficam fora.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Folha de compartilhar, papéis e visibilidade. Convite pendente, convite por link e transferir a posse ficam fora.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Acesso
Botão Compartilhar na capa da viagem ou toque nos avatares/“+” da capa.

## Folha alta
1. Cabeçalho “Compartilhar viagem” / nome da viagem.
2. **QUEM PLANEJA JUNTO**: linhas com avatar 40 px · nome (“(você)” no seu) · papel (12 px). À direita: etiqueta roxa **Dono** para o dono; para os demais, chip **Alterar ▾** (34 px).
3. **CONVIDAR ALGUÉM**:
   - Campo “E-mail da pessoa” (48 px).
   - “Papel na viagem” — 3 cartões selecionáveis (raio 16 px; selecionado borda 2 px `#2B207F` + fundo `#F8F7FF`), com ícone em quadrado roxo 36 px e ícone lima:
     | Ícone | Papel | Descrição |
     | --- | --- | --- |
     | olho | Assistente júnior de viagem | Só visualiza. Não vê documentos nem gastos |
     | lápis | Viajante experiente (**padrão**) | Vê e edita, mas não vê documentos |
     | coroa | Viajante supremo | Vê e edita tudo |
   - Botão **Enviar convite** (50 px).
4. **VISIBILIDADE**: segmentado **Privada** | **Pública**.
   - Privada: “Só você e quem você convidou veem esta viagem.”
   - Pública: “Aparece na busca. Outras pessoas veem o roteiro, avaliam e podem clonar. Gastos e documentos continuam privados.” + caixa com o link “mayahtrip.com/v/{id}” e botão lima **Copiar** (aviso “Link copiado”).

## Folha “Papel de {nome}”
- Os 3 cartões de papel com o atual marcado; tocar troca o papel, volta à folha anterior e mostra “{nome} agora é {papel}”.
- **🗑 Remover da viagem** (contorno, texto `#D2462A`) → remove e mostra “{nome} foi removido da viagem”.
- **Voltar**.

## Regras de negócio
1. O papel é definido **ao convidar** e pode ser alterado depois.
2. E-mail inválido → aviso “Digite um e-mail válido”. Válido → a pessoa aparece na lista com o papel escolhido (nome provisório = parte do e-mail antes do @) e aviso “Convite enviado para {e-mail} como {papel}”.
3. O convidado recebe notificação (app + push) e aceita/recusa (ver `06`). Recusa notifica quem convidou.
4. Matriz de permissões em `BUSINESS.md` §4.3.
5. Só o **Dono** altera papéis e remove pessoas (no protótipo, qualquer um vê os botões). Confirmar remoção: `A DEFINIR`.
6. Viagem pública: clonar copia o roteiro; gastos e documentos nunca são públicos.

## A DEFINIR
- Convite pendente (estado “aguardando” na lista) e reenvio.
- Convidar por link além de e-mail.
- Transferir a posse (novo Dono).

Estados desta fatia:

- Vazio: o que `26-compartilhar-viagem-e-papeis.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [ ] **AC-1** — Dado a capa, quando a pessoa toca Compartilhar ou o +, então a folha lista quem planeja junto e o papel padrão do convite é Viajante experiente; verificado por teste de widget.
- [ ] **AC-2** — Dado um e-mail inválido, quando a pessoa envia o convite, então o aviso diz “Digite um e-mail válido”; com e-mail válido, a pessoa entra na lista com o papel escolhido e o aviso confirma; verificado por teste de widget.
- [ ] **AC-3** — Dado o Dono, quando altera o papel, então o aviso diz “{nome} agora é {papel}”; Remover tira a pessoa da lista; verificado por teste de widget.
- [ ] **AC-4** — Dado visibilidade Pública, quando a pessoa copia o link, então o aviso diz “Link copiado” e o texto deixa claro que gastos e documentos continuam privados; verificado por teste de widget.
- [ ] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `26-compartilhar-viagem-e-papeis.md`; verificado por inspeção lado a lado.
- [ ] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; verificado por inspeção.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `26-compartilhar-viagem-e-papeis.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
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
| 5. Só o **Dono** altera papéis e remove pessoas (no protótipo, qualquer um vê os botões). Confirmar remoção: `A DEFINIR`. | não | produto | antes do refine-spec |
| ## A DEFINIR | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `compartilhar-viagem` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `viagem-capa` em `018-viagem-capa.md`
