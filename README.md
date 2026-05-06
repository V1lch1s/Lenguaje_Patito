# Lenguaje Patito

## Diagramas
![Diagramas Sintácticos](assets/diagrams.png)

> [!Importante]
> El código de Mermaid simplemente era muy grande para ponerlo aquí como un solo código de Mermaid. Revisar [código de Mermaid JS](assets/Patito_Diagramas.md)
---

## Reglas Gramaticales (Backus Naur Forms)
> &lt;Programa&gt; → programa id; &lt;declaración_Vars&gt; &lt;declaración_Funcs&gt; inicio &lt;CUERPO&gt; fin \
\
&lt;declaración_Vars&gt; → $\epsilon$ \
&lt;declaración_Vars&gt; → &lt;VARS&gt; \
\
&lt;declaración_Funcs&gt; → $\epsilon$ \
&lt;declaración_Funcs&gt; → &lt;FUNCS&gt; &lt;list_Funcs&gt; \
\
&lt;list_Funcs&gt; → $\epsilon$ \
&lt;list_Funcs&gt; → &lt;declaración_Funcs&gt;

---

> &lt;VARS&gt; → vars &lt;def_vars&gt; \
\
&lt;def_vars&gt; → &lt;identifiers&gt;: &lt;TIPO&gt;; &lt;Multi_var&gt; \
\
&lt;identifiers&gt; → id &lt;list_id&gt; \
\
&lt;list_id&gt; → $\epsilon$ \
&lt;list_id&gt; → ,&lt;identifiers&gt; \
\
&lt;Multi_var&gt; → $\epsilon$ \
&lt;Multi_var&gt; → &lt;def_vars&gt;

---

> &lt;FACTOR&gt; → (&lt;EXPRESIÓN&gt;) \
&lt;FACTOR&gt; → &lt;Add_Sust&gt;&lt;id_CTE&gt; \
&lt;FACTOR&gt; → &lt;LLAMADA&gt; \
\
&lt;Add_Sust&gt; → $\epsilon$ \
&lt;Add_Sust&gt; → + \
&lt;Add_Sust&gt; → - \
\
&lt;id_CTE&gt; → id \
&lt;id_CTE&gt; → &lt;CTE&gt;

---

> &lt;TIPO&gt; → entero \
&lt;TIPO&gt; → flotante

---

> &lt;CTE&gt; → cte_ent \
&lt;CTE&gt; → cte_flot

---

> &lt;CUERPO&gt; → {&lt;def_Est&gt;} \
\
&lt;def_Est&gt; → $\epsilon$
&lt;def_Est&gt; → &lt;Estatuto&gt;&lt;Multi_Statements&gt; \
\
&lt;Multi_Statements&gt; → $\epsilon$ \
&lt;Multi_Statements&gt; → &lt;def_Est&gt;

---

> &lt;ASIGNA&gt; → id = &lt;EXPRESIÓN&gt;;

---

> &lt;TÉRMINO&gt; → &lt;FACTOR&gt;&lt;Mult_Div&gt; \
\
&lt;Mult_Div&gt; → $\epsilon$ \
&lt;Mult_Div&gt; → *&lt;TÉRMINO&gt; \
&lt;Mult_Div&gt; → /&lt;TÉRMINO&gt;

---

> &lt;FUNCS&gt; → &lt;Func_Type&gt; id (&lt;def_Type&gt;){&lt;def_Var_Funcs&gt;&lt;CUERPO&gt;}; \
\
&lt;Func_Type&gt; → nula \
&lt;Func_Type&gt; → &lt;TIPO&gt; \
\
&lt;def_Type&gt; → $\epsilon$ \
&lt;def_Type&gt; → id:&lt;TIPO&gt;&lt;Multi_Type&gt; \
\
&lt;Multi_Type&gt; → $\epsilon$ \
&lt;Multi_Type&gt; → ,&lt;def_Type&gt; \
\
&lt;def_Var_Funcs&gt; → $\epsilon$ \
&lt;def_Var_Funcs&gt; → &lt;VARS&gt;

---

> &lt;EXPRESIÓN&gt; → &lt;EXP&gt;&lt;def_Exp&gt; \
\
&lt;def_Exp&gt; → $\epsilon$ \
&lt;def_Exp&gt; → &lt;Operator&gt;&lt;Exp&gt; \
\
&lt;Operator&gt; → >  \
&lt;Operator&gt; → <  \
&lt;Operator&gt; → != \
&lt;Operator&gt; → ==

---

> &lt;EXP&gt; → &lt;TÉRMINO&gt;&lt;Add_Sust_2&gt; \
\
&lt;Add_Sust_2&gt; → $\epsilon$ \
&lt;Add_Sust_2&gt; → +&lt;EXP&gt; \
&lt;Add_Sust_2&gt; → -&lt;EXP&gt;

---

> &lt;IMPRIME&gt; → escribe(&lt;Mensaje&gt;); \
\
&lt;Mensaje&gt; → letrero \
&lt;Mensaje&gt; → letrero&lt;Mensaje&gt; \
&lt;Mensaje&gt; → &lt;EXPRESIÓN&gt;&lt;Multi_Express&gt; \
\
&lt;Multi_Express&gt; → $\epsilon$ \
&lt;Multi_Express&gt; → ,&lt;Mensaje&gt;

---

> &lt;LLAMADA&gt; → id(&lt;Expression_Call&gt;) \
\
&lt;Expression_Call&gt; → $\epsilon$ \
&lt;Expression_Call&gt; → &lt;EXPRESIÓN&gt;&lt;Expression_list&gt; \
\
&lt;Expression_list&gt; → $\epsilon$ \
&lt;Expression_list&gt; → ,&lt;Expression_Call&gt;

---

> &lt;ESTATUTO&gt; → &lt;ASIGNA&gt;         \
&lt;ESTATUTO&gt; → &lt;CONDICIÓN&gt;        \
&lt;ESTATUTO&gt; → &lt;CICLO&gt;            \
&lt;ESTATUTO&gt; → &lt;LLAMADA&gt;          \
&lt;ESTATUTO&gt; → &lt;IMPRIME&gt;          \
&lt;ESTATUTO&gt; → [&lt;Estatuto_Anidado&gt;] \
\
&lt;Estatuto_Anidado&gt; → $\epsilon$ \
&lt;Estatuto_Anidado&gt; → &lt;ESTATUTO&gt;&lt;Multi_Sttmnt_2&gt; \
\
&lt;Multi_Sttmnt_2&gt; → $\epsilon$ \
&lt;Multi_Sttmnt_2&gt; → &lt;Estatuto_Anidado&gt;

---

> &lt;CICLO&gt; → mientras(&lt;EXPRESIÓN&gt;) haz&lt;CUERPO&gt;;

---

> &lt;CONDICIÓN&gt; → si(&lt;EXPRESIÓN&gt;)&lt;CUERPO&gt;&lt;Si_No&gt;; \
\
&lt;Si_No&gt; → $\epsilon$ \
&lt;Si_No&gt; → sino&lt;CUERPO&gt;




<!-- Para COPIAR Y PEGAR
&lt;declaración_Vars&gt; →  \
&lt;declaración_Funcs&gt; →  \
&lt;list_Funcs&gt; →  \
&lt;def_vars&gt; →  \
&lt;identifiers&gt; →  \
&lt;list_id&gt; →  \
&lt;Multi_var&gt; →  \
&lt;Add_Sust&gt; →  \
&lt;id_CTE&gt; →  \
&lt;def_Est&gt; →  \
&lt;Multi_Statements&gt; →  \
&lt;Mult_Div&gt; →  \
&lt;Func_Type&gt; →  \
&lt;def_Type&gt; →  \
&lt;Multi_Type&gt; →  \
&lt;def_Var_Funcs&gt; →  \
&lt;Operator&gt; →  \
&lt;def_Exp&gt; →  \
&lt;Add_Sust_2&gt; →  \
&lt;Mensaje&gt; →  \
&lt;Multi_Express&gt; →  \
&lt;Expression_Call&gt; →  \
&lt;Expression_list&gt; →  \
&lt;Multi_Sttmnt_2&gt; →  \
&lt;Estatuto_Anidado&gt; →  \
&lt;Si_No&gt; →  \

$\epsilon$

-->
