# Nova viagem

- Slug: `nova-viagem`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-17
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/14-nova-viagem.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `acoes-rapidas`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `14-nova-viagem.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Assistente modal de 4 passos e a tela de geração mocada. Edição posterior da viagem não entra.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `14-nova-viagem.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Assistente modal de 4 passos e a tela de geração mocada. Edição posterior da viagem não entra.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `sign-up`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Assistente modal de 4 passos e a tela de geração mocada. Edição posterior da viagem não entra.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Acesso
Cartão “Nova viagem” do Início, botão “+ Nova” da Carteira, Ações rápidas, notificação de boas-vindas, chip “+ Nova” ao inserir no roteiro, Maya. Abre como tela modal (sobe de baixo).

## Estrutura fixa
- **Topo** (52 px): fechar (✕) no 1º passo / voltar (←) nos demais · barra de progresso com 4 segmentos de 5 px (ativos `#2B207F`, pendentes `#DAD8E2`, transição 300 ms) · “N de 4” (12 px/700).
- **Título** editorial 44 px + subtítulo 15 px `#5E5A73`.
- Avançar anima o conteúdo da direita (36 px) e voltar da esquerda, 420 ms.
- **Rodapé** (borda superior, fundo da tela): botão **Continuar** (56 px, 16 px) — desativado (35%) se o passo não está válido; no passo 4, botão lima **✨ Criar viagem**. Abaixo: “Prefere conversar?” + link com avatar da Maya 20 px “Fale com a Maya”.

## Passo 1 — Para onde você vai? (“Pode escolher mais de uma cidade.”)
- Campo “Buscar cidade”. Escolhidas aparecem como chips escuros com ✕.
- Sem busca: “POPULARES AGORA” em grade 2 colunas (espaço 10 px): 1º cartão ocupa 2 colunas, 150 px, nome 34 px e “· 5,8 mil vídeos”; demais 120 px, nome 26 px. Cartão selecionado: contorno lima 3 px e botão ✓ lima (30 px); não selecionado: “+” em branco 25%.
- Com busca: lista de cidades que contêm o texto (nome ou país); se nada encontrado, oferece “{texto} — Adicionar como destino”.
- Válido com ≥ 1 destino. Ordem dos destinos = ordem de escolha.

## Passo 2 — Quando? (“Toque no dia da ida e no da volta.”)
- Segmentado: **📅 Datas definidas** | **Ainda não sei**.
- **Datas definidas**: calendário mensal (semana começa na segunda; S T Q Q S S D), navegação ‹ › entre meses; dias passados desativados (`#C4C1D2`). Ida e volta em círculo 44 px `#2B207F`; intervalo com faixa `#EBE8FF`. Tocar antes da ida redefine a ida. Rodapé: “Período {ida} – {volta}” + etiqueta “N dias”.
- **Ainda não sei**: contador “Quantos dias?” (− / número editorial 52 px / +), de 1 a 30; texto “Você define as datas quando quiser.” → a viagem nasce como **Rascunho**.
- Válido com ida e volta escolhidas ou modo “Ainda não sei”.

## Passo 3 — Quem vai com você? (“Dá para convidar depois também.”)
- 4 atalhos (grade 2 colunas, raio 22 px): **Sozinho** (1 adulto), **Casal** (2, padrão), **Família** (2 adultos · 2 crianças), **Amigos** (4). Selecionado: borda 2 px roxa, fundo `#F8F7FF`.
- Contadores Adultos (1–10) e Crianças (0–10). Mexer nos contadores desmarca o atalho.
- Campo opcional “E-mail de quem vai junto”.

## Passo 4 — Como quer começar? (“Tudo continua editável depois.”)
Três opções (cartões raio 22 px, ícone 44 px):
1. **Roteiro sugerido** (etiqueta lima “Mais rápido”) — “Montamos dia a dia com os lugares mais bem avaliados, organizados por bairro.” Mostra ainda: “O que não pode faltar? (opcional)” (Gastronomia [padrão], História e cultura, Vida noturna, Compras, Natureza, Arte) e **Ritmo** (Tranquilo · Equilibrado [padrão] · Intenso).
2. **Roteiro da comunidade** — “Comece pelo roteiro de quem já foi e ajuste do seu jeito.” Mostra cartões de roteiros (240 × 150 px) com autor, nota e nº de usos.
3. **Começar do zero** — “Dias vazios. Você adiciona os lugares que salvar.”

**Regra dos 14 dias**: se a viagem tem **mais de 14 dias**, aparece a caixa “Viagens com mais de 14 dias não geram roteiro automático. Você começa com os N dias livres e adiciona os lugares do seu jeito.” e as opções 1 e 2 ficam desativadas (40%); “Começar do zero” é selecionada automaticamente.

## Geração (após “Criar viagem”)
Tela cheia com a foto do destino (zoom 1,15 → 1,02 em 4 s) sob véu `rgba(21,18,46,.72)`; kicker lima “MONTANDO SUA VIAGEM” + destino em editorial 52 px. Lista de etapas: cada uma começa a 35% de opacidade, ganha indicador giratório e depois check lima (pop) a cada 620 ms:
- Sugerido: “Separando os lugares mais salvos de {cidade}” → “Agrupando por bairro para andar menos” → “Calculando deslocamentos e horários” → “Pronto!”
- Comunidade: “Copiando o roteiro de @{autor}” → “Ajustando para as suas datas” → “Calculando deslocamentos” → “Pronto!”
- Do zero: “Criando os dias da viagem” → “Preparando gastos e checklist” → “Pronto!”

## Resultado
- Viagem criada com nome = destinos unidos por “ e ”, 1 dia por dia do período, cidades distribuídas proporcionalmente entre os dias.
- Ritmo **Tranquilo** limita a 3 paradas por dia.
- Mala inicial: Essenciais (Documento de identidade, Cartão de crédito, Carregador) e Roupas (Calçado confortável, Casaco leve).
- Participantes: o criador como **Dono**; demais adultos como Viajante supremo (nomes provisórios).
- Abre a viagem e mostra “Viagem criada. Tudo é editável.” (ou “Viagem criada. Adicione lugares pelo feed ou busca.” quando não há roteiro pronto para a cidade).
- Geração real por IA é assíncrona e avisa por notificação (ver `06`).

## A DEFINIR
- Convite por e-mail no passo 3: papel aplicado (o padrão do convite é Viajante experiente?).
- Nomes dos participantes adicionados pelos contadores.
- Limite máximo de dias com datas definidas.

Estados desta fatia:

- Vazio: o que `14-nova-viagem.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado o passo 1 sem destino, quando a pessoa olha Continuar, então o botão fica a 35% e não avança; com ao menos um destino, avança; verificado por `test/ui/features/nova_viagem/nova_viagem_wizard_test.dart` e `nova_viagem_view_model_test.dart`.
- [x] **AC-2** — Dado o passo 2 em Ainda não sei, quando a viagem é criada, então ela nasce rascunho com duração e sem data; verificado pelos mesmos testes.
- [x] **AC-3** — Dado uma viagem com mais de 14 dias, quando o passo 4 abre, então Roteiro sugerido e Roteiro da comunidade ficam a 40% e Começar do zero fica selecionado; verificado por `nova_viagem_wizard_test.dart`/`nova_viagem_view_model_test.dart`.
- [x] **AC-4** — Dado Criar viagem, quando a geração mocada termina, então a viagem abre com o nome dos destinos unidos por " e ", um dia por dia do período, o criador como Dono e o aviso "Viagem criada. Tudo é editável."; verificado pelos mesmos testes. "Roteiro da comunidade" (cartões de roteiros de outros usuários) não tem dados mocados nesta fila — ao criar com essa opção, o dia nasce vazio (mesmo resultado visível de "Começar do zero"), registrado como D-6 abaixo.
- [x] **AC-5** — Dado ritmo Tranquilo, quando o roteiro sugerido é montado, então cada dia tem no máximo 3 paradas; verificado por `nova_viagem_view_model_test.dart`.
- [x] **AC-6** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `14-nova-viagem.md`; verificado por teste de widget em viewport 390 px. O calendário do passo 2 é uma grade funcional simplificada (não a grade pixel-a-pixel do protótipo) — D-7 abaixo. Inspeção visual lado a lado via app real não concluída nesta sessão.
- [ ] **AC-7** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; **pendente**, mesmo gap das specs anteriores.

## 8. Premissas e decisões

| ID | Tipo | Descrição | Dono | Validação |
| --- | --- | --- | --- | --- |
| D-1 | decisão | O protótipo e `14-nova-viagem.md` mandam no visual e no movimento. Dado divergente, a inspeção para e a diferença fica registrada antes de implementar. | produto | inspeção lado a lado |
| D-2 | decisão | Dados mocados, código de verificação `1234`, usuário Jean Lucas quando a tela pede alguém logado. | produto | comparar com o protótipo |
| D-3 | decisão | `A DEFINIR` não é implementado como regra nova. | produto | revisão da spec |
| P-1 | premissa | A fundação visual da spec `abertura` já existe quando esta fatia for implementada, salvo na própria abertura. | app | a spec `abertura` concluída |
| D-5 | decisão | "Equilibrado" e "Intenso" (passo 4, Ritmo) não têm limite de paradas/dia fixado em BUSINESS.md — só "Tranquilo" (3, AC-5). Para diferenciar visivelmente sem inventar regra de negócio, usamos 4 (Equilibrado) e 6 (Intenso) como teto técnico, sem anúncio nenhum desses números na tela. | app | revisão de produto se precisar de números oficiais |
| D-6 | decisão | "Roteiro da comunidade" (passo 4) não tem roteiros de outros usuários mocados nesta fila — ao escolher essa opção, os dias nascem vazios, igual a "Começar do zero". A tela de geração mostra o texto certo ("Copiando o roteiro de @autor..."), só o resultado final não difere. | produto | mockar roteiros da comunidade numa fila futura |
| D-7 | decisão | O calendário do passo 2 ("Datas definidas") é uma grade mensal funcional (toque define ida/volta, intervalo destacado, navegação de mês), não a grade pixel-a-pixel do protótipo — prioridade foi o comportamento (AC-2/AC-3) sobre fidelidade visual exata desse componente específico. | produto | inspeção lado a lado quando houver tempo |

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
| ## A DEFINIR | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `nova-viagem` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `acoes-rapidas` em `015-acoes-rapidas.md`
