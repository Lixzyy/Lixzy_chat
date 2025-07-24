let commandList = [];
let messageHistory = [];
let historyIndex = -1;

function setInputVisible(visible) {
    const inputWrapper = document.getElementById('chat-input-wrapper');
    const input = document.getElementById('chat-input');
    inputWrapper.style.display = visible ? 'block' : 'none';

    if (visible) {
        input.focus();
        historyIndex = -1;
    } else {
        input.blur();
        input.value = '';
        document.getElementById('chat-suggestions-list').style.display = 'none';
    }
}

function updateSuggestions() {
    const input = document.getElementById('chat-input');
    const suggestionsList = document.getElementById('chat-suggestions-list');
    const text = input.value.toLowerCase();

    suggestionsList.innerHTML = '';

    if (text.startsWith('/')) {
        const filteredCommands = commandList.filter(cmd => cmd.name.toLowerCase().startsWith(text));

        if (filteredCommands.length > 0) {
            suggestionsList.style.display = 'block';
            filteredCommands.forEach(cmd => {
                const item = document.createElement('div');
                item.className = 'suggestion-item';
                item.innerHTML = `<span class="cmd-name">${cmd.name}</span><span class="cmd-help">${cmd.help}</span>`;
                item.onclick = () => {
                    input.value = cmd.name + ' ';
                    input.focus();
                    updateSuggestions();
                };
                suggestionsList.appendChild(item);
            });
        } else {
            suggestionsList.style.display = 'none';
        }
    } else {
        suggestionsList.style.display = 'none';
    }
}

window.addEventListener('message', function(event) {
    const item = event.data;
    const messagesContainer = document.getElementById('chat-messages');
    switch (item.type) {
        case "ui":
            setInputVisible(item.display);
            break;
        case "setInputVisible":
            setInputVisible(item.payload);
            break;
        case "commandList":
            commandList = item.commands;
            break;
        case "clearChat":
            messagesContainer.innerHTML = '';
            break;
        case "notification":
            const notif = document.createElement('div');
            let iconClass = 'fa-solid fa-circle-info';
            if (item.nType === 'success') {
                iconClass = 'fa-solid fa-check-circle';
            } else if (item.nType === 'error') {
                iconClass = 'fa-solid fa-times-circle';
            }
            notif.className = `message notification ${item.nType}`;
            notif.innerHTML = `<i class="${iconClass}"></i> ${item.message}`;
            messagesContainer.appendChild(notif);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
            break;
        case "message":
            const newMessage = document.createElement('div');
            newMessage.className = 'message';
            newMessage.innerHTML = item.html;
            messagesContainer.appendChild(newMessage);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
            break;
    }
});

document.getElementById('chat-input').addEventListener('input', updateSuggestions);

document.addEventListener('keydown', function(event) {
    const input = document.getElementById('chat-input');
    if (document.getElementById('chat-input-wrapper').style.display === 'none') return;
    
    const key = event.key;

    if (key === 'Enter') {
        const message = input.value.trim();
        if (message !== '') {
            fetch(`https://${GetParentResourceName()}/chatMessage`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                body: JSON.stringify({ message: message })
            });
            if (messageHistory[0] !== message) {
                messageHistory.unshift(message);
            }
            if (messageHistory.length > 50) {
                messageHistory.pop();
            }
            setInputVisible(false);
        }
    } else if (key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/chatClosed`, {
            method: 'POST',
            body: JSON.stringify({})
        });
        setInputVisible(false);
    } else if (key === 'ArrowUp') {
        event.preventDefault();
        if (historyIndex < messageHistory.length - 1) {
            historyIndex++;
            input.value = messageHistory[historyIndex];
        }
    } else if (key === 'ArrowDown') {
        event.preventDefault();
        if (historyIndex > 0) {
            historyIndex--;
            input.value = messageHistory[historyIndex];
        } else {
            historyIndex = -1;
            input.value = '';
        }
    }
});