# 27 — Maya (assistente de dúvidas)

## Papel
A Maya **tira dúvidas e sugere atalhos**. Ela **não altera dados** (não cria viagem, não lança gasto, não mexe no roteiro por conta própria) — só oferece botões para o usuário fazer.

## Balão
- Canto inferior direito, 16 px da borda, 104 px da base; 52 px de altura, raio 26 px, fundo `#15122E` (noturno `#2B207F`), sombra forte.
- Avatar da Maya 38 px com borda lima 2 px + texto “Dúvidas? Maya” (14 px/700 branco).
- Fora das telas raiz: vira só o avatar (52 × 52 px) e desce para 24 px da base.
- Escondido em: Explorar, Assistente de viagem, Página do lugar, Abertura, Login e quando há uma folha aberta.

## Conversa (folha alta, fundo `#F4F3F8`)
- **Cabeçalho**: avatar 44 px · “Maya” · ponto verde `#7BD389` “Online”; botão fechar.
- **Mensagens**: da Maya à esquerda (balão branco, raio 20/20/20/6, avatar 28 px); do usuário à direita (`#2B207F`, branco, raio 20/20/6/20); 15 px, line-height 1,45; entram subindo.
- “Digitando…”: 3 pontos 7 px pulando.
- Primeira mensagem: “Oi, {nome}! Sou a Maya. Estou aqui para tirar dúvidas, sem atrapalhar. Em que posso ajudar?”
- **Rodapé**: perguntas rápidas em chips + campo “Pergunte qualquer coisa à Maya” (52 px) com botão enviar 38 px roxo.
  - Perguntas rápidas no assistente de viagem: “Não sei para onde ir” · “Posso mudar as datas depois?” · “Qual a diferença entre as opções?”
  - Nas demais telas: “Como crio uma viagem?” · “O que fazer à noite em Roma?” · “Como divido os gastos?”

## Atalhos que a Maya pode oferecer
| Pergunta | Resposta (resumo) | Atalho |
| --- | --- | --- |
| Como crio uma viagem? | Destino, datas, quem vai e como começar | Botão lima **+ Criar viagem agora** |
| O que fazer à noite em Roma? | Trastevere depois das 20h; Trevi tarde | Cartões de lugar → abrem a **página do lugar** |
| Como divido os gastos? | Lance, diga quem pagou e com quem dividir | **Lançar um gasto** (abre o formulário) |

Todos os atalhos apenas **abrem** a tela; a ação é concluída pelo usuário.

## Idioma
A Maya responde no idioma da interface ativo, e só nele: Português (Brasil) `pt-BR`, Português (Portugal) `pt-PT`, English `en` ou Español `es`. Perguntas rápidas, primeira mensagem e atalhos seguem o mesmo idioma.

## A DEFINIR
- Base de conhecimento e contexto da viagem usado nas respostas.
- Histórico da conversa entre sessões.
- Limites de uso (plano Free x PRO).
