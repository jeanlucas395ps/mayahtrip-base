# MayahTrip — Visão de negócio

> Fonte da verdade de negócio do app mobile MayahTrip. Cada funcionalidade tem seu próprio arquivo numerado nesta pasta (`00-…` a `35-…`). Este documento explica **por que** o produto existe, as **regras globais** que valem para todas as telas e o **glossário**. Os valores visuais (cores, tamanhos, tempos) vêm do protótipo interativo aprovado (`MayahTrip · protótipo interativo`, versão de 16 nov 2026).
>
> Convenção: tudo que ainda não foi decidido aparece como **`A DEFINIR`**. Nada marcado assim deve ser implementado por suposição — pergunte ao responsável de produto.

## 1. Propósito

O MayahTrip é um app para **planejar e viver viagens em um só lugar**, com foco em:

1. **Simplicidade** — criar uma viagem em 4 toques (destino, datas, quem vai, como começar). A IA ajuda, mas não é o caminho principal.
2. **Comunidade** — descobrir lugares por vídeos e avaliações reais de quem já foi (feed vertical no estilo TikTok) e levar o lugar direto para o roteiro.
3. **Organização do grupo** — roteiro, gastos divididos (estilo Splitwise), mala, lista de compras e documentos, compartilhados com quem viaja junto.

Slogan exibido na abertura: “Sua viagem, *inteira*, num só lugar.” Slogan do login: “Planeje menos. *Viaje mais.*”

## 2. Público

- Viajantes a lazer, sozinhos, em casal, em família ou com amigos.
- Usuário de referência do protótipo: **Jean Lucas** (@jeanlucas), brasileiro morando em Lisboa.
- Visitantes sem conta podem explorar como **convidado** (ver `04-modo-convidado.md`).

## 3. Princípios de produto

| Princípio | Como aparece no app |
| --- | --- |
| Poucos toques | Assistente de viagem em 4 passos; gasto lançado num único painel. |
| Comunidade antes da IA | Feed, dicas e roteiros de quem foi. A Maya fica num balão de dúvidas. |
| Nada se perde | Ações destrutivas oferecem **Desfazer** no aviso (toast) por 3,2 s. |
| Tudo editável | Datas, pessoas, roteiro e gastos podem ser alterados depois. |
| Offline para o essencial | Documentos ficam disponíveis sem internet. |

## 4. Regras globais

### 4.1 Notificações
- **Toda notificação é enviada no app (central de notificações) e por push.** Não existe notificação só in-app ou só push.
- Tipos atuais: roteiro gerado, convite para viagem, gasto lançado por outra pessoa, boas-vindas, código de verificação (e-mail), comentário/curtida/menção (ver `06`, `10`, `29`).
- Preferências por tipo de notificação: Usuário sempre recebo todas.

### 4.2 Idioma e moeda (ver `35-idioma-e-moeda.md`)
- A interface existe só em quatro idiomas: **Português (Brasil)** (`pt-BR`), **Português (Portugal)** (`pt-PT`), **English** (`en`) e **Español** (`es`). App, mensagens da API e painel usam os mesmos quatro.
- Por padrão, **idioma e moeda vêm da localização do usuário**, escolhendo um desses quatro. A opção padrão nas preferências é “Minha localização”.
- Se o usuário escolher um idioma ou moeda no perfil, **a escolha do perfil sempre prevalece** sobre a localização. O idioma escolhido é um dos quatro.
- Valores são armazenados na moeda original do lançamento e **exibidos convertidos** para a moeda de exibição pelo câmbio do dia.
- Fusos horários são sempre mostrados em relação à localização atual do usuário (ex.: “+1h”, “Mesmo horário de Lisboa”).

### 4.3 Papéis em uma viagem (ver `26-compartilhar-viagem-e-papeis.md`)
| Papel | Vê roteiro | Edita | Vê gastos | Vê documentos | Convida/exclui |
| --- | --- | --- | --- | --- | --- |
| Dono da viagem | ✅ | ✅ | ✅ | ✅ | ✅ |
| Viajante supremo | ✅ | ✅ | ✅ | ✅ | ✅ |
| Viajante experiente | ✅ | ✅ | ✅ | ❌ | ❌ |
| Assistente júnior de viagem | ✅ | ❌ (só visualiza) | ❌ | ❌ | ❌ |

O papel é escolhido **no momento do convite** e pode ser alterado depois pelo dono.

### 4.4 Status de uma viagem
| Status | Regra | Selo no cartão |
| --- | --- | --- |
| Rascunho | Tem duração (nº de dias), mas **não tem data** | “Rascunho”, canto **inferior direito** da imagem |
| Próxima | Data de início no futuro | “Em N dias”, canto superior esquerdo |
| Acontecendo agora | Hoje está entre o 1º e o último dia | “Acontecendo agora” com ponto pulsante, canto superior esquerdo |
| Concluída | Último dia já passou | “Concluída”, canto superior esquerdo |

### 4.5 Roteiro com IA
- Viagens com **mais de 14 dias não geram roteiro automático** (nem “sugerido” nem “da comunidade”); começam com os dias livres.
- A Maya **não altera dados** do usuário. Ela só responde e sugere atalhos (abrir lugar, criar viagem, lançar gasto).

### 4.6 Categorias de gasto (10, com ícone padronizado)
| # | Categoria | Ícone | Cor da legenda |
| --- | --- | --- | --- |
| 1 | Hospedagem | cama | `#2B207F` |
| 2 | Transporte | avião | `#6A5CE0` |
| 3 | Alimentação | talheres | `#A89BFF` |
| 4 | Atividades | ingresso | `#C9FF27` |
| 5 | Passeios | bússola | `#7CC243` |
| 6 | Compras | carrinho | `#F2B84B` |
| 7 | Transporte local | ônibus | `#5BC0EB` |
| 8 | Saúde | cruz | `#FF8A5B` |
| 9 | Comunicação | wi-fi | `#2FA88A` |
| 10 | Outros | três pontos | `#A6A2BC` |

Todos os ícones de categoria usam o **mesmo bloco visual**: quadrado de cantos arredondados (raio = 1/3 do lado), fundo `#EBE8FF` (`--soft`), ícone `#2B207F` (no modo noturno, ícone `#C9FF27`). A cor só aparece na barra e na bolinha da legenda “Por categoria”.

### 4.7 Sessão
- Usuário com sessão ativa **pula o login** e vai direto ao Início depois da abertura.
- Ao trocar a senha, **todas as sessões em outros aparelhos são encerradas**.
- “Sair” encerra a sessão local e volta ao login.

### 4.8 Desfazer e avisos (toasts)
- Aviso escuro (`#15122E`, texto branco), raio 18 px, ícone de check em círculo lima `#C9FF27` de 26 px.
- Fica 3,2 s na tela; entra com subida de 24 px + escala 0,94→1 em 450 ms; sai em 300 ms.
- Máximo de **2 avisos** empilhados; o mais antigo sai.
- Posição: 110 px acima da base da tela (16 px das laterais); na tela de login, 56 px do topo.

### 4.9 Social
- Bloqueio é mútuo e silencioso (a pessoa bloqueada não é avisada).
- Conteúdo de pessoas bloqueadas (posts, comentários, curtidas) não aparece para quem bloqueou.
- Silenciar só remove os posts da pessoa do feed de quem silenciou.

## 5. Identidade visual (tokens)

| Token | Claro | Noturno | Uso |
| --- | --- | --- | --- |
| `--pri` | `#2B207F` | `#2B207F` | Botões primários, destaques |
| `--lime` | `#C9FF27` | `#C9FF27` | Acento, selos, CTA secundário |
| `--ink` | `#15122E` | `#F1EFFA` | Texto principal |
| `--mut` | `#5E5A73` | `#A6A2BC` | Texto secundário |
| `--bg` | `#F4F3F8` | `#0E0C1D` | Fundo de tela |
| `--card` | `#FFFFFF` | `#19162E` | Cartões e folhas |
| `--line` | `#E5E3EC` | `#2B2747` | Bordas |
| `--line2` | `#EEECF3` | `#221F3B` | Divisórias internas |
| `--soft` | `#EBE8FF` | `#26214D` | Fundos suaves roxos |
| Erro | `#D2462A` | `#D2462A` | Erros, ações destrutivas |
| Valor devido | `#962A10` | — | “você deve …” |
| Valor a receber | `#3A6B00` | — | “te devem …” |
| Estrela | `#F5A524` | `#F5A524` | Notas |
| Curtido | `#FF5A6A` | `#FF5A6A` | Coração preenchido |
| Badge de notificação | `#FF5A36` | `#FF5A36` | Contador |
| Destaque de dica | fundo `#F1FFD1`, texto `#2C3A00` | — | Caixas de dica/IA |

Tipografia: **Plus Jakarta Sans** (400–800) para interface; **Instrument Serif** (400, com itálico) para títulos editoriais.

| Estilo | Tamanho | Peso | Extra |
| --- | --- | --- | --- |
| h1 | 30 px | 800 | letter-spacing −0,035em |
| h2 | 19 px | 800 | −0,025em |
| h3 | 16 px | 700 | −0,01em |
| Texto | 15 px | 400–600 | — |
| sm | 13 px | — | — |
| xs | 12 px | — | — |
| Kicker | 11 px | 800 | maiúsculas, +0,14em |
| Editorial | 26–64 px | 400 | Instrument Serif, line-height 1 |

Componentes base: botão 50 px de altura, raio 25 px, peso 700, 15 px; chip 38 px, raio 19 px; campo 52 px, raio 16 px, foco com borda `#2B207F` + halo 4 px `#EBE8FF`; cartão raio 24 px; botão de ícone 44 × 44 px circular; segmentado com fundo `#E9E7F0`, item ativo branco com sombra `0 1px 3px rgba(21,18,46,.12)`.

Movimento: curva principal `cubic-bezier(.32,.72,0,1)`; saída `cubic-bezier(.2,.8,.2,1)`; mola `cubic-bezier(.3,1.5,.5,1)`. Toque em botões reduz para escala 0,96. Com “reduzir movimento” ativado no aparelho, todas as animações duram ~0 ms.

Detalhes de cada tela: arquivos numerados. Modo noturno: `33-aparencia.md`.

## 6. Navegação global

- **Barra inferior** (88 px de altura, fundo branco 92% com desfoque 18 px, borda superior `#ECEAF2`): Início · Explorar · **[+]** · Carteira · Perfil. Aparece só nas 4 telas raiz.
  - Item: 62 px de largura, ícone 22 px, rótulo 11 px/600, cor `#6E6A82`; ativo `#2B207F` (noturno: lima).
  - Botão central **+**: 54 × 54 px, raio 20 px, fundo `#2B207F`, ícone lima 24 px, sombra `0 8px 20px rgba(43,32,127,.35)` → abre `13-acoes-rapidas.md`.
  - No Explorar, a barra fica escura (`rgba(12,10,28,.9)`), itens `#A9A6BC`, ativo branco.
- **Balão da Maya**: ver `27-maya.md`.
- Telas empilhadas entram da direita (480 ms, curva principal); a anterior recua 26% com brilho 0,9. Telas modais (assistente) sobem de baixo; a anterior encolhe para 0,94 com brilho 0,8.
- **Folhas (bottom sheets)**: fundo escurecido `rgba(21,18,46,.5)`; folha branca com raio 30 px no topo, altura máx. 92% (ou 88% fixa nas folhas “altas”); alça 40 × 5 px `#DAD8E2`. Arrastar a alça para baixo mais de 110 px (ou rápido, > 0,6 px/ms) fecha. Tocar no fundo fecha. Tecla Esc fecha.

## 7. Glossário

| Termo | Significado |
| --- | --- |
| Viagem | Conjunto de destinos, dias, pessoas, gastos, mala, compras e documentos. |
| Parada | Um lugar dentro de um dia do roteiro, com horário. |
| Deslocamento | Trecho entre duas paradas (a pé, carro, transporte), com tempo e distância. |
| Rascunho | Viagem com duração, mas sem data. |
| Carteira | Lista de todas as viagens do usuário. |
| Maya | Assistente virtual para dúvidas (não altera dados). |
| Avaliação | Publicação de um usuário sobre uma parada: mídias + nota + legenda. |
| Acerto | Registro de pagamento entre participantes para zerar saldos. |

## 8. Índice de funcionalidades

| Nº | Arquivo | Funcionalidade |
| --- | --- | --- |
| 00 | `00-abertura.md` | Tela de abertura |
| 01 | `01-login.md` | Login |
| 02 | `02-cadastro-e-verificacao.md` | Cadastro e verificação de e-mail |
| 03 | `03-recuperar-senha.md` | Recuperar senha |
| 04 | `04-modo-convidado.md` | Explorar como convidado |
| 05 | `05-inicio.md` | Início (home) |
| 06 | `06-notificacoes.md` | Notificações |
| 07 | `07-busca.md` | Busca |
| 08 | `08-pagina-do-lugar.md` | Página do lugar |
| 09 | `09-explorar-feed.md` | Explorar (feed de vídeos) |
| 10 | `10-comentarios-e-curtidas.md` | Comentários e curtidas |
| 11 | `11-inserir-no-roteiro.md` | Inserir lugar no roteiro |
| 12 | `12-avaliar-parada.md` | Avaliar parada (publicar) |
| 13 | `13-acoes-rapidas.md` | Ações rápidas (botão +) |
| 14 | `14-nova-viagem.md` | Nova viagem (assistente) |
| 15 | `15-carteira-de-viagens.md` | Carteira de viagens |
| 16 | `16-viagem-capa-e-abas.md` | Viagem: capa, informações e abas |
| 17 | `17-roteiro-lista.md` | Roteiro em lista |
| 18 | `18-roteiro-mapa-e-otimizacao.md` | Roteiro em mapa e otimização |
| 19 | `19-detalhe-da-parada.md` | Detalhe da parada |
| 20 | `20-adicionar-parada.md` | Adicionar parada |
| 21 | `21-gastos.md` | Gastos e divisão |
| 22 | `22-novo-gasto.md` | Novo gasto |
| 23 | `23-mala.md` | Mala |
| 24 | `24-lista-de-compras.md` | Lista de compras |
| 25 | `25-documentos-e-links.md` | Documentos e links |
| 26 | `26-compartilhar-viagem-e-papeis.md` | Compartilhar viagem e papéis |
| 27 | `27-maya.md` | Maya |
| 28 | `28-perfil.md` | Perfil |
| 29 | `29-publicacoes-midias-mencoes.md` | Gerenciar publicações, mídias e menções |
| 30 | `30-social.md` | Seguir, perfil público, silenciar, bloquear, denunciar |
| 31 | `31-privacidade-e-bloqueios.md` | Privacidade e bloqueios |
| 32 | `32-onde-ja-estive.md` | Onde já estive (mapa-múndi) |
| 33 | `33-aparencia.md` | Aparência (modo noturno) |
| 34 | `34-editar-perfil.md` | Editar perfil e foto |
| 35 | `35-idioma-e-moeda.md` | Idioma e moeda |

## 9. Fora do escopo atual

- Chat entre usuários (botão “Mensagem” removido).
- Selos “Explorador” e “verificado” (removidos).
- Galeria de fotos da viagem (substituída pela Lista de compras).
- Maya alterando dados.

## 10. Pendências gerais (`A DEFINIR`)

- Preço e features do PRO são gravados pelo administrador em `PANEL/08-planos.md`. Não há preço padrão no código.
- Preferências de notificação por tipo.
- Permissões de convidar/remover para “Viajante supremo” e “Viajante experiente”.
- Limites de mídia por avaliação (quantidade, tamanho, duração de vídeo).
- Política de moderação de denúncias (prazo, retorno ao denunciante).
- Ordenação “Para você” do feed (algoritmo).
