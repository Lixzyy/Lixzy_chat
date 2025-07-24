Chat NUI Avancé pour FiveM
Une ressource de chat complète, moderne et performante pour les serveurs FiveM, conçue pour remplacer avantageusement le chat par défaut d'ESX. Elle intègre une interface web (NUI), un système de suggestion dynamique et des fonctionnalités immersives comme l'affichage 3D.



# 📋 Fonctionnalités
Interface Moderne (NUI) : Un design épuré et personnalisable en HTML, CSS et JavaScript.

Suggestions de Commandes Dynamiques : Une liste de commandes s'affiche et se filtre en temps réel sous la barre de saisie, rendant la découverte des commandes intuitive.

Affichage 3D Immersif : Les commandes /me et /ooc s'affichent au-dessus de la tête du personnage, visibles par les joueurs à proximité, pour une meilleure immersion RP.

Système de Notifications Global : N'importe quelle autre ressource peut envoyer des notifications de succès, d'erreur ou d'information directement dans le chat.

Historique des Messages : Rappelez facilement vos derniers messages et commandes avec les flèches haut et bas.

Configuration Modulaire : Ajoutez facilement des commandes au système de suggestion depuis n'importe quelle autre ressource sans jamais modifier le code du chat lui-même.

Optimisé : Le code est conçu pour être léger et ne pas impacter les performances du serveur.

# 🛠️ Installation
Téléchargez ou clonez cette ressource dans votre dossier resources.


Assurez-vous que le chat par défaut d'ESX est bien désactivé dans votre server.cfg :

Puis ajouter la ligne suivante pour demarrer le chat:
ensure mon_chat

# ⚙️ Configuration et Utilisation
La force de ce chat réside dans sa capacité à interagir avec vos autres scripts.

Ajouter des Commandes au Système de Suggestion
Pour qu'une commande d'une autre ressource apparaisse dans la liste des suggestions, vous devez la "déclarer" à notre chat.

Modifiez le fichier côté client (client.lua) de la ressource qui contient la commande et ajoutez un événement.

Exemple : Vous avez une commande /radio dans une ressource my_radio.

-- Dans my_radio/client.lua

-- On attend que le chat soit bien chargé pour éviter les erreurs
Citizen.CreateThread(function()
    while GetResourceState('mon_chat') ~= 'started' do
        Citizen.Wait(500)
    end

    -- On déclare notre commande au système de suggestion du chat
    TriggerEvent('mon_chat:registerCommandSuggestion', {
        name = '/radio',
        help = 'Parler dans la radio de votre fréquence actuelle.'
    })
end)

N'importe quel script (côté client) peut envoyer une notification au chat. C'est très utile pour donner un retour visuel à l'utilisateur.

Utilisez l'événement mon_chat:addNotification avec deux arguments : le message et le type (success, error, info).

Exemple d'utilisation :

Lua

-- Dans n'importe quel script client

-- Notification de succès
TriggerEvent('mon_chat:addNotification', 'Vous avez bien reçu votre salaire.', 'success')

-- Notification d'erreur
TriggerEvent('mon_chat:addNotification', 'Vous n_avez pas assez d_argent.', 'error')

-- Notification d'information
TriggerEvent('mon_chat:addNotification', 'Le véhicule a bien été verrouillé.', 'info')


# 🔗 Dépendances
es_extended : (Optionnel, mais recommandé) Utilisé pour récupérer le nom RP des joueurs. Le script fonctionnera sans, mais affichera les noms Steam.

#📜 Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

# 👤 Auteur
Créé par Lixzy
N'hésitez pas à me contacter pour toute question ou suggestion.

