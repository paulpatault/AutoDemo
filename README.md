# AutoDemo
 
Outil de démonstration automatique. Prends deux formules logiques `𝗔` et `𝗕` en entrées, et vérifie que `𝗔 ⟹ 𝗕`.
    
# Usage

+ Compilation et exéctution :
    ```
    $ make
    $ ./main
    ```
+ Donner au programme les entrées : 
  > → remplir les trous en utilisant la bonne syntaxe, cf. [Syntaxe](#Syntaxe)
    ```
    ...
    $ Formule de gauche: __
    $ Formule de droite: __
    ...
    ```
+ Le résultat va s'afficher !
    > Exemple 1
    ```
    $ ./main
     Formule de gauche: A && B
     (A) et (B)
     Formule de droite: A || B
     (A) ou (B)
    
     ---- Évaluation ----
     (A) et (B) => (A) ou (B)   ( rule G∧ )
       (A)(B) => (A) ou (B)   ( rule Dv )
         (A)(B) => (A)(B)   → is axiom
    ```
    > Exemple 2
    ```
    $ ./main
     Formule de gauche: A || B
     (A) ou (B)
     Formule de droite: A && B
     (A) et (B)

     ---- Évaluation ----
     (A) ou (B) => (A) et (B)   ( rule G∨ )
       (A) => (A) et (B)   ( rule D∧ )
         (A) => (A)   → is axiom
         (A) => (B)   → impossible
    ```
  
  
# Syntaxe

| Mot                      | Syntaxe |
| :----------------------- | :-----: |
| Pour tout `∀`            |  `[A]`  |
| Il existe `∃`            |  `[E]`  |
| Égale `=`                |   `=`   |
| Différent `≠`            |  `<>`   |
| Inférieur `<`            |   `<`   |
| Et `∧`                   |  `&&`   |
| Ou `∨`                   | `\|\|`  |
| Implique `⇒`             |  ` =>`  |
| Parenthèses ouvrante `(` |   `(`   |
| Parenthèses fermante `)` |   `)`   |
| Séparateur `,`           |   `,`   |
| Formule `𝗔`              |   `𝗔`   |
| Variable `𝒙`             |   `𝒙`   |