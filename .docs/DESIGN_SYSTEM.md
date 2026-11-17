# Design system — contrato

A especificação visual completa está em `DESIGN.md` (extraída do protótipo “MayahTrip · protótipo interativo”, frame 390 × 844, 16 nov 2026). Este arquivo é o contrato curto: o que não pode ser violado ao construir tela no Flutter ou no painel.

Comportamento de cada tela: `BUSINESS/`. Se um pixel daqui divergir de `DESIGN.md`, `DESIGN.md` vence e este resumo deve ser corrigido.

## Voz

Duas camadas, juntas: revista de viagem (Instrument Serif, foto na borda, degradê escuro) e utilitário calmo (cartão branco, névoa `#F4F3F8`, uma cor de ação).

Slogan de produto: “Planeje menos. Viaje mais.” A Maya é um balão de dúvidas, nunca o centro da tela.

## Cores que importam

| Papel | Valor |
| --- | --- |
| Ação (única) | `#2B207F` |
| Acento | `#C9FF27` com texto `#15122E`, ou lima sobre roxo/escuro/foto |
| Texto | `#15122E` |
| Texto secundário | `#5E5A73` |
| Fundo | `#F4F3F8` |
| Cartão | `#FFFFFF` |
| Erro | `#D2462A` |
| Deve | `#962A10` |
| A receber | `#3A6B00` |

Modo noturno e a tabela inteira: `DESIGN.md`, seção Dark Mode. Feed, abertura, login e foto não trocam de tema.

## Regras

- Uma cor de ação: o roxo. Lima não é texto sobre fundo claro.
- Ícones de uma mesma família usam o mesmo bloco e a mesma cor. A cor da categoria de gasto aparece na barra e na bolinha da legenda, não no ícone.
- Ícone em bloco roxo é lima. Ícone em bloco lavanda `#EBE8FF` é roxo.
- Instrument Serif só em nome de lugar, nome de viagem, nome de pessoa no perfil, número de destaque e frase de marca. Botão, rótulo, campo e lista ficam em Plus Jakarta Sans.
- Sem emoji.
- Foto do usuário é sempre circular.
- Carrossel horizontal começa a 20 px da esquerda, alinhado à margem da tela.
- Remoção oferece Desfazer no toast (3,2 s).
- Selo de viagem: “Em N dias” e “Acontecendo agora” no canto superior esquerdo da imagem; “Rascunho” no canto inferior direito.
- Sem selo Explorador, sem selo verificado, sem botão de mensagem no perfil.
- Texto da interface via `gen_l10n` (app) ou i18n (painel), nos quatro idiomas: Português (Brasil) `pt-BR`, Português (Portugal) `pt-PT`, English `en`, Español `es`. Nenhuma frase fixa no componente.

## Componentes de referência

Altura de botão 50 px (CTA de tela 54–56). Campo 52 px, raio 16 px, foco com borda `#2B207F` e halo 4 px `#EBE8FF`. Barra inferior 88 px com o botão central “+”. Folha com raio 30 px no topo. Detalhe de cada um: `DESIGN.md`, seção Components.

## Movimento

Curva principal `cubic-bezier(.32, .72, 0, 1)`. Toque comprime para 0,96. Com reduzir movimento, duração ~0 ms. Não animar em loop, salvo o ponto “ao vivo” e a seta do feed.

## Flutter

Mapeamento: `ThemeExtension` próprio (cores) e fontes empacotadas como assets — decididos em 2026-11-16, ver `DESIGN.md` seção Flutter mapping e ADR em `mayahtrip-app/adrs/`. Pacote de ícones (estilo linha 24 px traço 2) continua `A DEFINIR`; não escolha no meio de uma tela.

## Não fechar sozinho

- Pacote de ícones.
- Mapa real (claro e noturno).
- Fonte grande do sistema.
- Tablet e largura menor que 360 px.
- Ilustração de estado vazio além do ícone.
- Ícone do app e splash nativa.
