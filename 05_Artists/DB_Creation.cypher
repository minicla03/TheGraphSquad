// Pulizia del database
MATCH (n) DETACH DELETE n;

// Creazione artisti
CREATE (a1:Artista {nome: "Sergio il Mimo", disciplina: "Mimo", anni: 10});
CREATE (a2:Artista {nome: "Bea la Fiammeggiante", disciplina: "Mangiafuoco", anni: 13});
CREATE (a3:Artista {nome: "Tom il Trapezista", disciplina: "Trapezio", anni: 2});
CREATE (a4:Artista {nome: "Nina la Magica", disciplina: "Magia", anni: 3});
CREATE (a5:Artista {nome: "Leo il Domatore", disciplina: "Domatore", anni: 6});
CREATE (a6:Artista {nome: "Vale l'Equilibrista", disciplina: "Equilibrio", anni: 7});
CREATE (a7:Artista {nome: "Ricky il Giocoliere", disciplina: "Giocoleria", anni: 8});

// Creazione spettacoli
CREATE (s1:Spettacolo {nome: "Il Mondo Incantato", tipo: "Magia", durata: 2});
CREATE (s2:Spettacolo {nome: "Fiamme e Fuoco", tipo: "Fuoco", durata: 1.5});
CREATE (s3:Spettacolo {nome: "Volando Alto", tipo: "Acrobazie", durata: 1.5});
CREATE (s4:Spettacolo {nome: "La Fattoria del Circo", tipo: "Animali", durata: 1.5});

// Creazione luoghi
CREATE (l1:Luogo {nome: "Chapiteau Centrale", paese: "Torino", capienza: 1000});
CREATE (l2:Luogo {nome: "Arena delle Meraviglie", paese: "Bologna", capienza: 800});
CREATE (l3:Luogo {nome: "Piazza del Circo", paese: "Venezia", capienza: 1200});
CREATE (l4:Luogo {nome: "Giardino delle Bestie", paese: "Genova", capienza: 500});

// Equipaggiamento
CREATE (e1:Equipaggiamento {nome: "Torce Infuocate", num: 6});
CREATE (e2:Equipaggiamento {nome: "Trapezio Volante", num: 2});
CREATE (e3:Equipaggiamento {nome: "Cappello Magico", num: 1});
CREATE (e4:Equipaggiamento {nome: "Frusta", num: 2});
CREATE (e5:Equipaggiamento {nome: "Fune per Equilibrismo", num: 3});

// Partecipazioni agli spettacoli
MATCH (a1:Artista {nome: "Sergio il Mimo"}), (s1:Spettacolo {nome: "Il Mondo Incantato"})
CREATE (a1)-[:PARTECIPA_A]->(s1);

MATCH (a2:Artista {nome: "Bea la Fiammeggiante"}), (s2:Spettacolo {nome: "Fiamme e Fuoco"})
CREATE (a2)-[:PARTECIPA_A]->(s2);

MATCH (a2:Artista {nome: "Bea la Fiammeggiante"}), (s3:Spettacolo {nome: "Volando Alto"})
CREATE (a2)-[:PARTECIPA_A]->(s3);

MATCH (a3:Artista {nome: "Tom il Trapezista"}), (s3:Spettacolo {nome: "Volando Alto"})
CREATE (a3)-[:PARTECIPA_A]->(s3);

MATCH (a4:Artista {nome: "Nina la Magica"}), (s1:Spettacolo {nome: "Il Mondo Incantato"})
CREATE (a4)-[:PARTECIPA_A]->(s1);

MATCH (a5:Artista {nome: "Leo il Domatore"}), (s4:Spettacolo {nome: "La Fattoria del Circo"})
CREATE (a5)-[:PARTECIPA_A]->(s4);

MATCH (a6:Artista {nome: "Vale l'Equilibrista"}), (s2:Spettacolo {nome: "Fiamme e Fuoco"})
CREATE (a6)-[:PARTECIPA_A]->(s2);

MATCH (a7:Artista {nome: "Ricky il Giocoliere"}), (s3:Spettacolo {nome: "Volando Alto"})
CREATE (a7)-[:PARTECIPA_A]->(s3);

MATCH (a7:Artista {nome: "Ricky il Giocoliere"}), (s1:Spettacolo {nome: "Il Mondo Incantato"})
CREATE (a7)-[:PARTECIPA_A]->(s1);

// Luoghi spettacoli
MATCH (s1:Spettacolo {nome: "Il Mondo Incantato"}), (l1:Luogo {nome: "Chapiteau Centrale"})
CREATE (s1)-[:SI_TIENE_IN]->(l1);

MATCH (s2:Spettacolo {nome: "Fiamme e Fuoco"}), (l2:Luogo {nome: "Arena delle Meraviglie"})
CREATE (s2)-[:SI_TIENE_IN]->(l2);

MATCH (s3:Spettacolo {nome: "Volando Alto"}), (l3:Luogo {nome: "Piazza del Circo"})
CREATE (s3)-[:SI_TIENE_IN]->(l3);

MATCH (s4:Spettacolo {nome: "La Fattoria del Circo"}), (l4:Luogo {nome: "Giardino delle Bestie"})
CREATE (s4)-[:SI_TIENE_IN]->(l4);

MATCH (s3:Spettacolo {nome: "Volando Alto"}), (l4:Luogo {nome: "Giardino delle Bestie"})
CREATE (s3)-[:SI_TIENE_IN]->(l4);

MATCH (s1:Spettacolo {nome: "Il Mondo Incantato"}), (l4:Luogo {nome: "Giardino delle Bestie"})
CREATE (s1)-[:SI_TIENE_IN]->(l4);

// Equipaggiamento usato
MATCH (a2:Artista {nome: "Bea la Fiammeggiante"}), (e1:Equipaggiamento {nome: "Torce Infuocate"})
CREATE (a2)-[:UTILIZZA_EQUIPAGGIAMENTO]->(e1);

MATCH (a3:Artista {nome: "Tom il Trapezista"}), (e2:Equipaggiamento {nome: "Trapezio Volante"})
CREATE (a3)-[:UTILIZZA_EQUIPAGGIAMENTO]->(e2);

MATCH (a4:Artista {nome: "Nina la Magica"}), (e3:Equipaggiamento {nome: "Cappello Magico"})
CREATE (a4)-[:UTILIZZA_EQUIPAGGIAMENTO]->(e3);

MATCH (a5:Artista {nome: "Leo il Domatore"}), (e4:Equipaggiamento {nome: "Frusta"})
CREATE (a5)-[:UTILIZZA_EQUIPAGGIAMENTO]->(e4);

MATCH (a6:Artista {nome: "Vale l'Equilibrista"}), (e5:Equipaggiamento {nome: "Fune per Equilibrismo"})
CREATE (a6)-[:UTILIZZA_EQUIPAGGIAMENTO]->(e5);

MATCH (a7:Artista {nome: "Ricky il Giocoliere"}), (e1:Equipaggiamento {nome: "Torce Infuocate"})
CREATE (a7)-[:UTILIZZA_EQUIPAGGIAMENTO]->(e1);

// Amicizie
MATCH (a1:Artista {nome: "Sergio il Mimo"}), (a4:Artista {nome: "Nina la Magica"})
CREATE (a1)-[:AMICO_DI]->(a4);

MATCH (a2:Artista {nome: "Bea la Fiammeggiante"}), (a3:Artista {nome: "Tom il Trapezista"})
CREATE (a2)-[:AMICO_DI]->(a3);

MATCH (a2:Artista {nome: "Bea la Fiammeggiante"}), (a5:Artista {nome: "Leo il Domatore"})
CREATE (a2)-[:AMICO_DI]->(a5);

MATCH (a3:Artista {nome: "Tom il Trapezista"}), (a6:Artista {nome: "Vale l'Equilibrista"})
CREATE (a3)-[:AMICO_DI]->(a6);

MATCH (a4:Artista {nome: "Nina la Magica"}), (a7:Artista {nome: "Ricky il Giocoliere"})
CREATE (a4)-[:AMICO_DI]->(a7);

MATCH (a5:Artista {nome: "Leo il Domatore"}), (a6:Artista {nome: "Vale l'Equilibrista"})
CREATE (a5)-[:AMICO_DI]->(a6);

MATCH (a6:Artista {nome: "Vale l'Equilibrista"}), (a7:Artista {nome: "Ricky il Giocoliere"})
CREATE (a6)-[:AMICO_DI]->(a7);

MATCH (a1:Artista {nome: "Tom il Trapezista"}), (a2:Artista {nome: "Sergio il Mimo"})
CREATE (a1)-[:AMICO_DI]->(a2);