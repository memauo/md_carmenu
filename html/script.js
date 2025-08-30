window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action == 'menu') {
        const cont = document.getElementById('cont');
        if (data.closed==0){
            cont.style.display = "flex"
        } else {
            cont.style.display = "none"
        }
    }
});

function openDoor(door) {
    fetch(`https://${GetParentResourceName()}/toggleDoor`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json; charset=UTF-8',},
        body: JSON.stringify({door})
    });
}
function rollWindow(window){
    fetch(`https://${GetParentResourceName()}/toggleWindow`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json; charset=UTF-8',},
        body: JSON.stringify({window})
    });
}

function changeSeat(seat){
    fetch(`https://${GetParentResourceName()}/switchSeat`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json; charset=UTF-8',},
        body: JSON.stringify({seat})
    });
}
function engine(){
    fetch(`https://${GetParentResourceName()}/toggleEngine`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json; charset=UTF-8',},
        body: JSON.stringify({})
    });
}