#ifndef __ARBRE__
#define __ARBRE__

typedef struct arbre {
    int nombre;
    struct arbre * fg;
    struct arbre * fd;
    int equilibre;
    int hauteur;
}
Arbre;
typedef Arbre * pArbre;
typedef struct chainon {
    pArbre arbre;
    int nombre;
    struct chainon * suivant;
}
Chainon;
typedef Chainon * pListe;

typedef struct file {
    Chainon * queue;
    Chainon * tete;
}
File;

//ds------------------------------
void parcoursmoy(pArbre a, int * c, int * somme);
float moyennefg(pArbre a);
float moyennefd(pArbre a);
void MinMaxABR(pArbre a, int min, int max);
//partie arbre----------------------
pArbre creerArbre(int a);
int estVide(pArbre a);
int estFeuille(pArbre a);
int element(pArbre a);
int existeFilsGauche(pArbre a);
int existeFilsDroit(pArbre a);
pArbre ajouterFilsGauche(pArbre a, int e);
pArbre ajouterFilsDroit(pArbre a, int e);
void traiter(pArbre a);
void parcoursPrefixe(pArbre a);
void parcoursPostFixe(pArbre a);
void parcoursInfixe(pArbre a);
void parcoursLargeurs(pArbre a);
pArbre modifierRacine(pArbre a, int e);
void supprimerFilsDroit(pArbre a);
void supprimerFilsGauche(pArbre a);
pArbre filsGauche(pArbre a);
pArbre filsDroit(pArbre a);
int max(int a, int b);
int taille(pArbre a);
int nbmFeuille(pArbre a);
int hauteur(pArbre a);

//partie file
Chainon * creationChainon(pArbre a);
int verif(File * file);
int enfiler(File * f, pArbre a);
pArbre defiler(File * f);
void creerfile(File * f);

//partie liste chainee
typedef Chainon * pListe;
pListe creerChainon();
int element_liste_chainee(pListe p1);
void traiter_liste_chainee(pListe p1);
pListe insertFin(pListe p1, int n);
pListe insertDebut(pListe p1, int n);
pListe insertMilieu(pListe p1, int e);
pListe suppDebut(pListe p1);
pListe triselection(pListe p1, int n);
int taille_liste_chainee(pListe p1);
pListe parcours_i(pListe p1);

//void affArbreGraphique(pArbre a,int info);
//partie Arbre binaire de recherche

int recherche(pArbre a, int e);
pArbre insertionABR(pArbre a, int e);
pArbre insertionABRIter(pArbre a, int e);
pArbre insertionABRIter2(pArbre a, int e);
pArbre suppMax(pArbre a, int * e);
pArbre suppressionABR(pArbre a, int e);

//partie AVL
int min(int a, int b);
int min_of_three(int a, int b, int c);
int max(int a, int b);
int max_of_three(int a, int b, int c);
pArbre rotationDroite(pArbre a);
pArbre rotationGauche(pArbre a);
pArbre doubleRotationDroite(pArbre a);
pArbre doubleRotationGauche(pArbre a);
pArbre equilibrerAVL(pArbre a);
pArbre insertionAVL(pArbre a, int e, int * h);
pArbre suppMinAVL(pArbre a, int * h, int * pe);
pArbre suppressionAVL(pArbre a, int e, int * h);
//void MinMaxABR(pArbre a, int *min, int *max);
#endif
