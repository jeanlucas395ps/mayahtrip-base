# 35 — Idioma e moeda

## Regra principal
- **Idioma e moeda padrão vêm do lugar onde o usuário está.**
- A opção padrão, enquanto o usuário não escolhe nada, é **“Minha localização”** para os dois.
- Se o usuário escolher um idioma ou moeda, **a escolha do perfil sempre é respeitada**, mesmo que ele mude de país.
- Referência do protótipo: usuário em Lisboa, Portugal → Português (Portugal) e Euro (€).

## Acesso
Perfil → Configurações → **Idioma e moeda** (à direita: “Minha localização” ou “Personalizado”).

## Folha alta
- Cabeçalho “Idioma e moeda” / “Por padrão usamos sua localização: {cidade}, {país}”.
- **IDIOMA** (cartão, fundo da tela): Minha localização (“{idioma da localização}”) e, em seguida, só estes quatro: Português (Brasil), Português (Portugal), English, Español. Seleção com marcador redondo 24 px.
- **MOEDA DE EXIBIÇÃO**: Minha localização (“{moeda local}”) · Euro (€) · Real (R$) · Dólar (US$) · Libra (£).
- Nota 12 px: “Fusos horários são mostrados em relação à sua localização. Gastos em outras moedas são convertidos pelo câmbio do dia.”
- Avisos: “Idioma: minha localização” / “Idioma atualizado”; “Valores exibidos em {moeda}”.

## Efeitos no app
1. Todos os valores (gastos, orçamento, preços de lugares, lista de compras, notificações de gasto) são exibidos na moeda de exibição, convertidos pelo câmbio do dia.
2. Novo gasto e lista de compras começam na moeda de exibição.
3. Fuso nas informações da viagem é relativo à localização atual (“+1h”, “Mesmo horário de Lisboa (sua localização)”).
4. O formato numérico segue o idioma da interface e a moeda de exibição.
   - Português (Brasil) e Português (Portugal): milhar “.”, decimal “,” (1.234,56).
   - English: milhar “,”, decimal “.” (1,234.56).
   - Español: milhar “.”, decimal “,” (1.234,56).

## Idiomas da interface

A interface inteira (app, API nas mensagens ao usuário e painel) existe só nestes quatro idiomas. Não há outro locale.

| Idioma | Código | “Minha localização” quando o país é |
| --- | --- | --- |
| Português (Brasil) | `pt-BR` | Brasil. Também é o idioma quando a localização não está disponível |
| Português (Portugal) | `pt-PT` | Portugal |
| English | `en` | EUA, Reino Unido, Canadá, Austrália |
| Español | `es` | Espanha, México, Argentina, Colômbia |

“Minha localização” escolhe um destes quatro. País que não está na tabela usa Português (Brasil). A escolha explícita no perfil substitui a localização e também é um destes quatro.

Sem permissão de localização: idioma Português (Brasil) e moeda Real (R$).

E-mail transacional (verificação, senha, convite) sai no idioma da interface de quem recebe. Se essa pessoa ainda não tem conta, o e-mail usa o idioma de quem enviou. A Maya responde no mesmo idioma da interface ativa. Nenhum desses textos existe fora dos quatro idiomas.

Câmbio do dia: `api.frankfurter.dev`.

## Moedas de exibição

| Moeda | Código |
| --- | --- |
| Real brasileiro | BRL (padrão, junto com Português (Brasil), quando não há localização) |
| Dólar americano | USD |
| Libra esterlina | GBP |
| Dólar canadense | CAD |
| Dólar australiano | AUD |
| Euro | EUR |
| Peso mexicano | MXN |
| Franco suíço | CHF |
| Yuan chinês | CNY |
| Iene japonês | JPY |
