import TaskManagerLib

let taskManager = createTaskManager()

let create = taskManager.transitions.filter{$0.name=="create"}[0]
let spawn = taskManager.transitions.filter{$0.name=="spawn"}[0]
let exec = taskManager.transitions.filter{$0.name=="exec"}[0]
let success = taskManager.transitions.filter{$0.name=="success"}[0]
let fail = taskManager.transitions.filter{$0.name=="fail"}[0]

let taskPool = taskManager.places.filter{$0.name=="taskPool"}[0]
let processPool = taskManager.places.filter{$0.name=="processPool"}[0]
let inProgress = taskManager.places.filter{$0.name=="inProgress"}[0]

//Problème

let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
print(m1!)//1 token dans taskPool,0 token dans processPool et 0 token dans inProgress
let m2 = spawn.fire(from: m1!)
print(m2!)//1 token dans taskPool,1 token dans processPool et 0 token dans inProgress
let m3 = spawn.fire(from: m2!)
print(m3!)//1 token dans taskPool,2 token dans processPool et 0 token dans inProgress
let m4 = exec.fire(from: m3!)
print(m4!)//1 token dans taskPool,1 token dans processPool et 1 token dans inProgress
let m5 = exec.fire(from: m4!)
print(m5!)//1 token dans taskPool,0 token dans processPool et 2 token dans inProgress
let m6 = success.fire(from: m5!)
print(m6!)//0 token dans taskPool,0 token dans processPool et 1 token dans inProgress

//D'après l'énoncé il ne devrait pas y avoir de tâche dans l'ensemnle
//des tâches à exécuter si on réussit la tâhce or ici il reste 1 token
//dans InProgress.De plus si la prochaine éxécution est "let m7 = fail.fire(from: m6!)"
//alors il n'y aura plus de token dans aucune place(aussi contradictoire avec l'énoncé)




//Exercice 4

//Déclaration des variables

let correctTaskManager = createCorrectTaskManager()

let create1 = correctTaskManager.transitions.filter{$0.name=="create"}[0]
let spawn1 = correctTaskManager.transitions.filter{$0.name=="spawn"}[0]
let exec1 = correctTaskManager.transitions.filter{$0.name=="exec"}[0]
let success1 = correctTaskManager.transitions.filter{$0.name=="success"}[0]
let fail1 = correctTaskManager.transitions.filter{$0.name=="fail"}[0]

let taskPool1 = correctTaskManager.places.filter{$0.name=="taskPool"}[0]
let processPool1 = correctTaskManager.places.filter{$0.name=="processPool"}[0]
let inProgress1 = correctTaskManager.places.filter{$0.name=="inProgress"}[0]
let correcteur = correctTaskManager.places.filter{$0.name=="correcteur"}[0]

//Solution
let m01 = create1.fire(from: [taskPool1: 0, processPool1: 0, inProgress1: 0, correcteur:0])
print(m01!)//1 token dans taskPool,0 token dans processPool , 0 token dans inProgress et 1 dans correcteur
let m02 = spawn1.fire(from: m01!)
print(m02!)//1 token dans taskPool,1 token dans processPool , 0 token dans inProgress et 1 dans correcteur
let m03 = spawn1.fire(from: m02!)
print(m03!)//1 token dans taskPool,2 token dans processPool , 0 token dans inProgress et 1 dans correcteur
let m04 = exec1.fire(from: m03!)
print(m04!)//1 token dans taskPool,1 token dans processPool , 1 token dans inProgress et 0 dans correcteur
let m05 = success1.fire(from: m04!)
print(m05!)//0 token dans taskPool,1 token dans processPool , 0 token dans inProgress et 0 dans correcteur
//Ici on montre le succés puisqu'il n'y a plus de tâches dans TaskPool et Inprogress
let m06 = fail1.fire(from: m04!)
print(m06!)//1 token dans taskPool,1 token dans processPool , 0 token dans inProgress et 1 dans correcteur
//Ici on montre l'échec puisque le procésseur n'est pas détruit et la tâche est toujours dans l’ensembles de tâches à exécuter
