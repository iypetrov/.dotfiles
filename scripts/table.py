import matplotlib.pyplot as plt
import pandas as pd
import textwrap

data = {
    "Работен пакет номер": ["1", "2", "3", "4", "Общо"],
    "вид разходи": [
        "Изготвяне на техническа архитектура",
        "Дизайн на потребителски интерфейс",
        "Интеграционен дизайн за съвместимост с инструменти",
        "Разработка на модули за активност, документация и тестове",
        "Общо"
    ],
    "А: труд (персонал)": ["5000", "6000", "5500", "8000", "24500"],
    "Б: материални (техника) и нематериални (софтуер) активи": ["2000", "2500", "1500", "3500", "9500"],
    "В: други (пътни, зали, кетъринг, консумативи, хостинг такси...)": ["500", "300", "400", "600", "1800"],
    "Г: подизпълнител": ["1000", "1500", "1200", "2000", "5700"],
    "общо директни (А+Б+В+Г)": ["8500", "10300", "8600", "14100", "41500"],
    "индиректни (режийни) (А+Б+В)*10%": ["750.0", "880.0", "740.0", "1210.0", "3580.0"],
    "общо (директни + индиректни)": ["9250.0", "11180.0", "9340.0", "15310.0", "45080.0"]
}

df = pd.DataFrame(data)

for column in df.columns:
    df[column] = df[column].apply(lambda x: textwrap.fill(x, width=100))

fig, ax = plt.subplots(figsize=(20, 20))
ax.axis("tight")
ax.axis("off")

table = ax.table(
    cellText=df.values,
    colLabels=df.columns,
    cellLoc="center",
    loc="center",
)

table.auto_set_font_size(False)
table.set_fontsize(10)

for i, column in enumerate(df.columns):
    column_width = max(df[column].apply(lambda x: len(max(x.split("\n"), key=len))))
    table.auto_set_column_width([i])
    table._cells[(0, i)].set_width(column_width * 0.03)

for row_idx, row in enumerate(df.values):
    max_lines = max([len(cell.split("\n")) for cell in row])
    for col_idx, cell in enumerate(row):
        table._cells[(row_idx + 1, col_idx)].set_height(max_lines * 0.03)

file_path = "table.png"
plt.savefig(file_path, bbox_inches="tight", dpi=300)
