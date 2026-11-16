# 10 — Comentários e curtidas

## Objetivo
Ver e participar da conversa de uma publicação e ver quem curtiu.

## Onde abre
| Origem | Aba inicial |
| --- | --- |
| Feed → botão de comentários | Comentários |
| Perfil / Minhas publicações → contador de comentários | Comentários |
| Perfil / Minhas publicações → contador de curtidas | Curtidas |

## Layout (folha alta, 88% da tela)
1. **Cabeçalho**: título h2 = “@{autor}” (post de outra pessoa) ou “Sua publicação”; subtítulo 13 px “{lugar · cidade}”; botão fechar 40 px.
2. **Seletor** (segmentado): “💬 Comentários · {total}” | “♡ Curtidas · {total}”.

### Aba Comentários
- Lista de comentários, mais recentes primeiro, divididos por linhas `#EEECF3`.
- **Comentário** (padding 12 px): avatar 32 px · linha 12 px: **@usuário** (ou “{nome} (você)”), selo roxo **Autor** (18 px, 10 px) quando quem comenta é o autor do post, “· {tempo}” · texto 13 px (line-height 1,45) · ações 12 px: **Responder**; **Excluir** (seu comentário) ou **Remover** (comentário de outra pessoa no **seu** post), ambos em `#D2462A`.
- À direita: coração 16 px + contador 11 px; curtido = `#FF5A6A`.
- **Respostas**: recuo de 42 px, avatar 26 px, sem botão “Responder” (só um nível).
- **Ver mais comentários ({restantes})**: botão contorno 44 px; carrega de 8 em 8.
- **Vazio**: “Nenhum comentário ainda” / “Seja a primeira pessoa a comentar.”
- **Rodapé fixo** (fundo do cartão, borda superior): sua foto 36 px · campo 46 px “Adicione um comentário” (máx. **500** caracteres) · botão enviar 46 px redondo `#2B207F`.
  - Modo resposta: acima do campo, “Respondendo a **@usuário**” + link **Cancelar**; placeholder “Escreva sua resposta”; teclado foca no campo.

### Aba Curtidas
- Lista: avatar 40 px · @usuário (13 px/700) · nome (12 px) · botão **Seguir** (primário 34 px) ou **Seguindo** (contorno). Seu próprio registro aparece primeiro como “{nome} (você) — Você curtiu”, sem botão.
- Rodapé 12 px: “e outras pessoas · total {N}”.
- Seguir pela lista atualiza a lista e mostra o aviso de seguir.

## Regras de negócio
1. Enviar comentário vazio não faz nada.
2. Novo comentário entra no **topo** com “agora” e soma 1 ao total; a lista volta ao topo.
3. Resposta entra no fim das respostas daquele comentário; **não** soma ao total de comentários.
4. Excluir/Remover pede **Desfazer** no aviso (“Comentário excluído” / “Comentário removido”). Excluir um comentário remove também as respostas dele.
5. O dono da publicação pode remover qualquer comentário do próprio post; qualquer pessoa pode excluir os próprios comentários.
6. Comentários e respostas de usuários **bloqueados** não aparecem.
7. Convidado: pode ver, mas ao enviar abre o convite “Crie sua conta para comentar”.
8. Curtir comentário: alterna, soma/subtrai 1.
9. O contador de comentários do feed e do perfil acompanha o total.
10. Novo comentário, resposta e curtida geram notificação ao autor (app + push).

## A DEFINIR
- Menções com @ dentro de comentários.
- Denunciar comentário.
- Ordenação alternativa (mais curtidos).
- Editar comentário.
