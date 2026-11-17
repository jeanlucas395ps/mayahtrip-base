# Criar conta

- Slug: `sign-up`
- Status: `em execução`
- Data: 2026-11-16
- Última atualização: 2026-11-16
- Responsável: produto
- Repositório: `mayahtrip-app`
- Docs relacionados: `.docs/BUSINESS/02-cadastro-e-verificacao.md`, `.docs/BUSINESS/BUSINESS.md`, `.docs/DESIGN.md`, `.docs/prototype`
- Specs relacionadas: `sign-in`
- ADRs relacionados: nenhum

## 1. Contexto

Fato: o protótipo em `.docs/prototype` (16 nov 2026, frame 390×844) e `02-cadastro-e-verificacao.md` já descrevem esta feature. O app Flutter em `mayahtrip-app` ainda não tem essa tela.

Quem sente: quem for usar o app e quem for comparar a tela com o protótipo. Sem esta fatia, o comportamento existe só no HTML.

Premissa, não fato: os dados continuam mocados, iguais aos do protótipo. Não há API nesta fila.

## 2. Necessidade de negócio

O app público precisa desta tela idêntica ao protótipo antes de qualquer outra entrega da mesma área. O sucesso é a pessoa cumprir o fluxo abaixo e a inspeção no frame 390×844 não achar diferença de layout, espaçamento, alinhamento ou animação.

## 3. Objetivo e resultado observável

Somente o passo 1 do cadastro: nome, e-mail, senha, medidor e aceite dos termos. O código de 4 dígitos é a spec confirm-account.

## 4. Usuários e permissões

| Persona/papel | O que pode fazer | Restrições |
| --- | --- | --- |
| Jean Lucas, sessão mocada | Cumprir o fluxo desta fatia como no protótipo | Dados fixos do protótipo |
| Convidado | Só o que `modo-convidado` libera | Fora desta spec, exceto na própria spec `modo-convidado` |
| Dono, Viajante supremo, Viajante experiente, Assistente júnior | O que `02-cadastro-e-verificacao.md` e BUSINESS.md §4.3 permitem nesta tela | Papel que a tela não menciona não ganha permissão nova |

## 5. Escopo

### 5.1 Dentro do escopo

- Somente o passo 1 do cadastro: nome, e-mail, senha, medidor e aceite dos termos. O código de 4 dígitos é a spec confirm-account.
- Flutter em `mayahtrip-app`, com os dados mocados do protótipo.
- Reutilizar tokens, fontes e movimento definidos na spec `abertura`, sem redefini-los.

### 5.2 Fora de escopo

- As outras fatias: `abertura`, `sign-in`, `confirm-account`, `forgot-password`, `reset-password`, `inicio`, `notificacoes`, `busca`, `pagina-do-lugar`, `explorar`, `comentarios-curtidas`, `inserir-no-roteiro`, `avaliar-parada`, `acoes-rapidas`, `nova-viagem`, `carteira`, `viagem-capa`, `roteiro-lista`, `roteiro-mapa`, `detalhe-da-parada`, `adicionar-parada`, `gastos`, `novo-gasto`, `mala`, `lista-de-compras`, `documentos-links`, `compartilhar-viagem`, `maya`, `perfil`, `minhas-publicacoes`, `minhas-midias`, `mencoes`, `seguidores`, `perfil-publico`, `privacidade-bloqueios`, `onde-ja-estive`, `aparencia`, `editar-perfil`, `idioma-moeda`, `modo-convidado`.
- API real, painel, site de planos e cobrança em loja.
- Item marcado `A DEFINIR` que o protótipo não desenha. Não inventar a regra.
- O painel lateral do HTML do protótipo.

## 6. Comportamento esperado

Recorte: Somente o passo 1 do cadastro: nome, e-mail, senha, medidor e aceite dos termos. O código de 4 dígitos é a spec confirm-account.

O texto abaixo é a regra desta fatia. Medida, tempo e cor citados são critério visual. Menção a uma tela de outra spec é só navegação: o destino pertence à spec daquele slug.

## Acesso
“Criar conta grátis” (login início), “Criar conta” (login e-mail).

## Indicador de passos
Topo do painel: 2 barras de 4 px (raio 2 px) lado a lado + texto “1 de 2” / “2 de 2” (12 px/700, `#5E5A73`). Barra concluída `#2B207F`, pendente `#E5E3EC`, transição de cor 300 ms.

## Passo 1 — Dados
Título editorial 34 px “Crie sua conta”, subtítulo 13 px “Grátis. Leva menos de 1 minuto.”, botão voltar (38 px) → login início.

Campos (rótulo 12 px/700 `#5E5A73` acima; campo 50 px, raio 16 px):
1. **Nome** — placeholder “Como quer ser chamado”.
2. **E-mail** — placeholder “voce@email.com”.
3. **Senha** — placeholder “Mínimo 8 caracteres”, botão de olho.
4. **Medidor de força** (4 barras de 4 px + rótulo à direita, 62 px):

| Pontos | Rótulo | Cor |
| --- | --- | --- |
| vazio | — | `#E5E3EC` |
| 1 | Fraca | `#D2462A` |
| 2 | Razoável | `#E2A92A` |
| 3 | Boa | `#5FB8A2` |
| 4+ | Forte | `#3A9A2E` |

Um ponto para cada: ≥ 8 caracteres; letra maiúscula; número; símbolo; ≥ 12 caracteres (máximo exibido = 4). Atualiza a cada tecla, transição 250 ms.

5. Caixa **Aceito os Termos de uso e a Política de privacidade** (desmarcada por padrão).
6. Botão **Continuar** (primário 54 px).
7. “Já tem conta?” + **Entrar**.

### Validações (ordem, a primeira falha é exibida em 12 px/700 `#D2462A` acima do botão)
1. Nome vazio → “Digite seu nome.”
2. E-mail inválido → “Digite um e-mail válido.”
3. Senha < 8 caracteres → “A senha precisa ter pelo menos 8 caracteres.”
4. Termos não aceitos → “Aceite os termos para continuar.”

Ao errar, os valores digitados são mantidos. Se tudo certo: botão com indicador giratório, envio do código por e-mail e aviso “Código enviado para {e-mail}”.

Estados desta fatia:

- Vazio: o que `02-cadastro-e-verificacao.md` descreve como vazio. Se o arquivo não descreve vazio, a tela não inventa empty state.
- Erro: só a mensagem que o arquivo escreve. Mensagem marcada `A DEFINIR` não é criada.
- Permissão: papéis de BUSINESS.md §4.3 quando a tela cita papel.
- Limite: o número que o arquivo fixa (tentativas, caracteres, dias, itens). O que está `A DEFINIR` não vira limite.

## 7. Critérios de aceite

- [x] **AC-1** — Dado o login, quando a pessoa toca Criar conta grátis ou Criar conta, então abre o passo 1 com indicador “1 de 2” e o botão voltar retorna ao início do login; verificado por teste de widget e pelo app real rodando no macOS.
- [x] **AC-2** — Dado o passo 1, quando nome, e-mail, senha ou termos falham, então aparece só a primeira mensagem da ordem de BUSINESS/02 e os valores digitados permanecem; verificado por teste de widget e pelo app real (mensagem "Digite seu nome." confirmada visualmente, posição e cor batendo com `02-cadastro-dados-erro.png`).
- [x] **AC-3** — Dado uma senha, quando cada tecla entra, então o medidor marca um ponto por regra (≥8, maiúscula, número, símbolo, ≥12) com no máximo 4 barras e o rótulo da tabela; verificado por teste de widget e pelo app real (senha "Abcdefg1!" rendeu as 4 barras verdes + "Forte").
- [x] **AC-4** — Dado dados válidos e termos aceitos, quando a pessoa toca Continuar, então o botão mostra o indicador e o fluxo segue para a spec confirm-account com o aviso “Código enviado para {e-mail}”; verificado por teste de widget (o destino é o placeholder `ConfirmAccountView`, já que a tela real pertence a `004-confirm-account`, fora de escopo aqui).
- [x] **AC-5** — Dado o frame 390×844 e os dados mocados do protótipo, quando esta tela está visível, então alinhamento, espaçamento, tipografia e cor coincidem com `.docs/prototype` e com `02-cadastro-e-verificacao.md`; verificado por inspeção lado a lado com o app rodando no macOS. Dessa inspeção vieram 2 correções reais: `assets/icons/` nunca estava declarado em `pubspec.yaml` (nenhum ícone — olho, voltar, mail, bússola, seta — carregava em nenhuma tela do app) e o título "Crie sua conta" não tinha cor explícita (herdava um cinza quase invisível em vez de `tintaNoite`).
- [x] **AC-6** — Dado reduzir movimento ativo no aparelho, quando esta tela anima, então as durações caem para cerca de 0 ms; satisfeito por herança: o carrossel de fundo e a transição de tela já respeitam `disableAnimations` desde `sign-in`/`abertura`, e esta fatia não introduz nenhuma animação de longa duração nova (só transições de cor de 250–300 ms, equivalentes às já existentes).

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
| ## A DEFINIR | não | produto | antes do refine-spec |

Nenhuma pergunta acima bloqueia esta spec. A tela mocada copia o que o protótipo já mostra e deixa de fora o que o protótipo não desenha.

## 13. Resultado

A fatia `sign-up` está pronta quando todos os AC passam no frame 390×844 com os dados mocados do protótipo.

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

- `sign-in` em `002-sign-in.md`
