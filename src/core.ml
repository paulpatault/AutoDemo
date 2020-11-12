open Types


(********************************************
*                                           *
*              Axiome                       *
*                                           *
********************************************) 

let rec insert (x : 'a) (l : 'a list) : 'a list list =
  match l with
  | [] -> [ [ x ] ]
  | h :: t ->
      let r = insert x t in
      (x :: l) :: List.map (fun v -> h :: v) r

let rec permutations (l : 'a list) : 'a list list =
  match l with
  | [] -> [ [] ]
  | h :: t ->
      let r = permutations t in
      List.fold_left (fun acc p -> insert h p @ acc) [] r

let rec contient (l1: 'a list) (l2: 'a list): bool = 
  match l2 with 
  | [] -> true 
  | e::k -> List.exists (fun e' -> e' = e) l1 && contient l1 k

let is_axiom (seq: sequent): bool = 
  contient seq.gauche seq.droite ||
  contient seq.droite seq.gauche ||
  List.exists (fun e -> seq.gauche = e) (permutations seq.droite) 


(********************************************
*                                           *
*              Réduction                    *
*                                           *
********************************************) 

let rotate_up l = try List.tl l @ [ List.hd l ] with Failure _ -> l 

let rec reduction ?(turn = -1) (seq: sequent): sequent list = 
  (* Rappel : 
    A₁, ..., Aₙ ⊢ B₁,...,Bₖ  
    ⟺ (A₁ ∧ . . . ∧ Aₙ) ⇒ (B₁ ∨ . . . ∨ Bₖ)
  *)
  match seq.gauche, seq.droite with 
  (*  Rule : G∨ 
         Γ, F ⟹ Δ     Γ, G ⟹ Δ
        --------------------------
             Γ, F ∨ G ⟹ Δ 
  *)  
  | Or (f, g) :: gamma, sd -> 
      Printf.printf "   ( rule G∨ )";
      let gamma' = if gamma = [Vide] then [] else gamma in
      let s1 = { gauche = f :: gamma'; droite = sd } in 
      let s2 = { gauche = g :: gamma'; droite = sd } in       
      [s1;s2]

  (*  Rule : G∧ 
         Γ, F,G ⟹ Δ 
       ----------------
        Γ, F ∧ G ⟹ Δ 
  *) 
  | And (f, g) :: gamma, sd -> 
      Printf.printf "   ( rule G∧ )";
      let gamma' = if gamma = [Vide] then [] else gamma in
      let s = { gauche = f :: g :: gamma'; droite = sd } in
      [s]

  (* Rule : G ⟶ 
         Γ ⟹ Δ, F     Γ, G ⟹ Δ
        ---------------------------
             Γ, F ⟶ G ⟹ Δ 
  *) 
  | Implies (f, g) :: gamma, sd -> 
      Printf.printf "   ( rule G→ )";
      let gamma' = if gamma = [Vide] then [] else gamma in
      let s1 = { gauche = gamma; droite = f :: sd } in 
      let s2 = { gauche = g :: gamma'; droite = sd } in 
      [s1;s2]
 
  (* Rule : G¬ 
        Γ ⟹ Δ, F 
      --------------
        Γ, ¬F ⟹ Δ
  *) 
  | Not f :: gamma, sd -> 
      Printf.printf "   ( rule G¬ )";
      let seq_res = { gauche = gamma; droite = f :: sd } in 
      [seq_res]
  
  (* | [Vide], sd -> [ {gauche = [Vide]; droite = [Vide]} ] *)

  | gamma, sd -> 
      if turn = List.length gamma 
      then reduction_droite gamma sd else
      reduction {gauche = rotate_up gamma; droite = sd} ~turn:(turn+1)

and reduction_droite ?(turn = -1) (gamma: formule list) (fl: formule list) : sequent list =
  if turn = List.length fl then raise Loose else
  match fl with
  | [] -> []
  | e :: k -> 
    begin match e with 
    (*  Rule : D∨ 
            Γ ⟹ ∆, F, G    
          -----------------
            Γ ⟹ ∆, F ∨ G
    *)
    | Or (f, g) -> 
        Printf.printf "   ( rule Dv )";
        let d = f :: g :: k in
        let seq_res = { gauche = gamma; droite = d } in 
        [seq_res]
    (*  Rule : D∧ 
          Γ ⟹ ∆, F     Γ ⟹ ∆, G
        ----------------------------
              Γ ⟹ ∆, F ∧ G
    *) 
    | And (f, g) -> 
        Printf.printf "   ( rule D∧ )";
        let s1 = { gauche = gamma; droite = f :: k } in 
        let s2 = { gauche = gamma; droite = g :: k } in 
        [s1;s2]

    (* Rule : D⟶ 
         Γ, F ⟹ ∆,G      
      ------------------
        Γ ⟹ ∆, F ⟶ G
    *) 
    | Implies (f, g) -> 
        Printf.printf "   ( rule D→ )";
        let gamma' = if gamma = [Vide] then [] else gamma in
        let seq_res = { gauche = f :: gamma'; droite = g :: k } in
        [seq_res]
    
    (* Rule : D¬ 
        Γ, G ⟹ ∆
      --------------
        Γ ⟹ ∆, ¬G
    *) 
    | Not f' ->
        Printf.printf "   ( rule D¬ )";
        let gamma' = if gamma = [Vide] then [] else gamma in
        let seq_res = { gauche = f' :: gamma'; droite =  k } in 
        [seq_res]
    
    | _ -> reduction_droite gamma (rotate_up fl) ~turn:(turn+1)
    end 