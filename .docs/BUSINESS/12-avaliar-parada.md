# 12 — Avaliar parada (publicar)

## Objetivo
O usuário pode **avaliar qualquer parada** publicando **1 ou mais fotos ou vídeos**, uma **nota** e uma **legenda**. A avaliação vira uma publicação no perfil e alimenta a página do lugar e o feed.

## Onde abre
- Detalhe da parada → botão **★ Avaliar esta parada**.
- Aviso “{lugar} feito” → ação **Avaliar** (após marcar uma parada como feita).
- Ações rápidas → **Publicar vídeo ou review**.

## Layout (folha alta)
1. Cabeçalho “Avaliar parada” / “{lugar} · {cidade}”.
2. **FOTOS E VÍDEOS · {N}** (kicker): fila horizontal de miniaturas **96 × 128 px**, raio 16 px:
   - Foto: imagem cortada. Vídeo: quadro do vídeo + selo “▶ Vídeo”.
   - A **primeira** mídia recebe o selo lima **Capa**.
   - Botão ✕ (26 px, `rgba(21,18,46,.7)`) no canto remove a mídia.
   - Último item: área tracejada (2 px `#CFCCDA`) “+ Adicionar fotos ou vídeos” que abre a galeria do celular com **seleção múltipla** (fotos e vídeos).
   - Sem mídia: dica 12 px “Adicione pelo menos 1 foto ou vídeo. A primeira mídia vira a capa.”
3. **SUA NOTA**: 5 estrelas em botões 52 × 52 px (raio 16, fundo `#F4F3F8`); selecionadas `#F5A524`, demais `#D5D3DE`. Começa **sem nota**.
4. **LEGENDA**: área de texto (3 linhas, máx. **500** caracteres) “Conte como foi e deixe uma dica para quem vai depois”.
5. **Etiquetas** opcionais (múltipla escolha, chips): Melhor horário · Vale o preço · Fila grande · Romântico · Bom para crianças.
6. Botão **Publicar avaliação** (54 px). Desativado (opacidade 45%) até ter **≥ 1 mídia e nota**. Abaixo, motivo: “Falta adicionar mídia e dar uma nota” / “Falta adicionar pelo menos 1 foto ou vídeo” / “Falta dar uma nota”.

## Regras de negócio
1. Obrigatórios: pelo menos 1 mídia e nota de 1 a 5. Legenda e etiquetas são opcionais (sem legenda, publica “Sem legenda.”).
2. Ao publicar: fecha a folha, cria a publicação no topo de “Publicações” do perfil (curtidas 0, comentários 0, data do mês atual) e mostra “Avaliação publicada em {lugar}” + **Ver** (abre o Perfil).
3. Cartão da publicação: capa = primeira foto (se a primeira mídia for vídeo, mostra duração; se houver mais de uma mídia, selo “1/N”).
4. Convidado → convite “Crie sua conta para avaliar paradas”.
5. Avaliar não depende de a parada estar marcada como feita.

## A DEFINIR
- Máximo de mídias por avaliação, tamanho máximo e duração máxima de vídeo.
- Reordenar mídias / escolher outra capa.
- Moderação antes de publicar.
- Se uma nova avaliação do mesmo lugar substitui ou soma à anterior.
