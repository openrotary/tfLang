#! border

| :selection / * | width(60)

| :index / 序号 |

|< #name / Name |
> strong : {{ row.name }}

|< age / Age |

|< addres / Address |

| #action / Action |
> Button type(primary) size(small) @click(show(index)) : View
    >> Button type(danger) size(small) @click(delete(index)) : Delete
