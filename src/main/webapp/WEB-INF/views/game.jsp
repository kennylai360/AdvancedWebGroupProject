<jsp:include page="../templates/gameHeaderTemplate.jsp"/>

<script>
    var userData = [];
    var availableRooms = [];
    curUser = '${user}';
    var globalUserList = [];
    var curRoomData;
    var userObjData;

    function createUserListDisplay(){
        if($('#userDisplay').length > 0){
            $('#userDisplay').remove();
        }

        var source   = $("#users-template").html();
        var template = Handlebars.compile(source);
        var newPage = template(curRoomData);

        $('#userList').append(newPage);
    }

    function getUser(){
        $.ajax({
            url:"/getUser",
            type:'GET',
            success:function(data) {
                userObjData = data;
                return false;
            }
        });
    }

    function getJoinedRoom(){
        $.ajax({
            url:"/getJoinedRoom",
            type:'GET',
            success:function(data) {
                getUserList();
                console.log(data);
                curRoomData = data;
                getUser();
                createUserListDisplay();
                if (curRoomData.listOfUsers.length == 2) {
                    console.log("HERE");
                    initialiseDrawer();
                    makeDrawer();
                    getMaxRounds();
                }
                console.log("getjoinedroom thing");
                return false;
            }
        });
    }
    $(window).load(function(){
        $.ajax({
            url:"/getUser",
            type:'GET',
            success:function(data) {
                userData = data;
                curRoom = userData.gameRoomId;
                drawConnect(curRoom);
                getJoinedRoom();
//                chooseRole();
                return false;
            }
        });
    });
    /*
     Removes user from GlobalList.
     Indicating that the user has logged out from the game server.
     */
    function removeUser(){
        var thisUser = curUser;
        $.ajax({
            url:"/removeUser",
            type:'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            data: JSON.stringify(curUser),
            success:function(data) {
                sendDisconnection(curRoom);
                drawDisconnect(curRoom);
                console.log("Success!!");
                return false;
            }
        });
    }

    /*
     Removes user from GlobalList.
     Indicating that the user has logged out from the game server.
     */
    function resetUser(){
        $.ajax({
            url:"/resetUser",
            type:'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            data: JSON.stringify(userObjData),
            success:function(data) {
                spliceTheArray();
                sendDisconnection(curRoom);
                drawDisconnect(curRoom);
                console.log("Success!!");
                return false;
            }
        });
    }
    function spliceTheArray() {
        console.log(curUser);

        for(i=0;i<curRoomData.listOfUsers.length;i++){
            if(curRoomData.listOfUsers[i].name == curUser){
                curRoomData.listOfUsers.splice(i-1,1);
                console.log(curUser);
            }
        }
        updateRoomUserList();
    }
    /*
     Removes user from GlobalList.
     Indicating that the user has logged out from the game server.
     */
    function updateRoomUserList(){
        $.ajax({
            url:"/updateRoomUserList",
            type:'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            data: JSON.stringify(curRoomData),
            success:function(data) {
                console.log("Success!!");
                                window.location.href = "/";
                return false;
            }
        });
    }

    $( window ).on('beforeunload',function() {
        resetUser();

    });
    function sendClear() {
        clearCanvas();
        sendDrawing(-1);
    }
    function sendColor(val) {
        onColourChange(val);
//        sendDrawing(-2,1,false,1,val);
    }
    
    function makeDrawer() {
        var userPosition = 0;
        //Finds current user in curRoomData in order to access isDrawer
        for (i = 0; i < curRoomData.listOfUsers.length; i++) {
            if (curRoomData.listOfUsers[i].name == curUser) {
                userPosition = i;
            }
        }
        if (curRoomData.listOfUsers[userPosition].isDrawer == 1) {
            //Indicates drawer
            prepareCanvas(1);
        }
        else {
            //Indicates guesser
            prepareCanvas(0);
        }
    }
    
    function chooseRole() {
        if (confirm("Choose a role! OK is Drawer. Cancel is Guesser.") == true) {
            // Indicates Drawer
            prepareCanvas(1);
        } else {
            // Indicates Guesser
            prepareCanvas(0);
        }
    }
    var time = 60;
    setInterval(refreshTimer,1000);

    function refreshTimer() {
        if (time > 0) {
            time--;
            document.getElementById("timer").innerHTML= time;
        }
        else {

        }
    }

    window.onload = function() {
        document.getElementById("timer").innerHTML=time;
    }
    
    function endGame() {
        for (i = 0; i < curRoomData.listOfUsers.length; i++) {
            if (curRoomData.listOfUsers[i].name == curUser) {
                userPosition = i;
            }
        }
        if (curRoomData.listOfUsers[userPosition].isWinner = 1) {
            Command: toastr["success"]("Congratulations, you won!", "You won!")
        }
    }


//toastr.options = {
//  "closeButton": true,
//  "debug": false,
//  "newestOnTop": false,
//  "progressBar": false,
//  "positionClass": "toast-top-full-width",
//  "preventDuplicates": false,
//  "onclick": null,
//  "showDuration": "300",
//  "hideDuration": "1000",
//  "timeOut": "500000",
//  "extendedTimeOut": "100000",
//  "showEasing": "swing",
//  "hideEasing": "linear",
//  "showMethod": "fadeIn",
//  "hideMethod": "fadeOut"
//}

</script>
<script id="users-template" type="text/x-handlebars-template">
    <h5><b><u>Users in-lobby [{{listOfUsers.length}}/4]</u></b></h5>
        <div id="userDisplay" style="padding-left:10px;">
        {{#each listOfUsers}}
            <p id="{{name}}">{{name}}: 0</p>
        {{/each}}
        </div>
</script>



<div class="container preventSelection" style="padding-top:30px;">
    <div class="row">
        <div class="col-md-offset-3" style="padding-bottom:5px">
            <div style="border: black 1px solid; height:20px; border-radius: 20px; ">
                <div class="row">
                    <div class="col-md-12">
                        <c:choose>
                            <c:when test = "${drawer == 1}">
                                <b> Word: </b> ${word}
                            </c:when>
                        </c:choose>

                        <b>Timer:</b> <a id="timer"</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-3">
            <div style="border: black 1px solid; height:175px; border-radius: 20px;">
                <div id="userList" style="padding-top:5px; padding-left:5px;">

                </div>
            </div>
            <div style="padding:5px;"></div>
            <div style="border: black 1px solid; height:310px; border-radius: 20px;" id="conversationDiv">
                <div style="padding-top:10px; padding-left:5px;">
                    <h5><b><u>Chat</u></b></h5>

                    <div id="scrollChat">
                        <!-- ENTER YOUR CHAT CODE BELOW -->
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-offset-3" id="canvasDiv" style="border: black 1px solid;height:500px; border-radius: 20px">
        </div>

    </div>

    <div class="row preventSelection" style="padding-top:5px;">
        <div class="col-md-4" style="border: black 1px solid; height:50px;  border-radius: 20px; padding-top:5px">
            <div> <!--Add some sort of javascript thing to disable drawing tools if the user is a guesser -->
                <label title="Brush tool"><img src="../icons/pencil_btn.png" onClick="pencilButtonClick()"
                                               height="30"/></label>
                <label title="Eraser tool"><img src="../icons/eraser_btn.png" onClick="eraserButtonClick()"
                                                height="30"/></label>
                <label title="Colour of the brush">
                    <input type="color" id="colourSelector" onchange="sendColor(this.value)" value="#000000"/></label>
                <label title="Width of the brush">
                    <input class="form-control" type="number" min="1" id="lineWidthSelector" style="width:75px;"
                           value="5"
                           onchange="autoValidateLineWidthInput()"/></label>
                <label title="Clear the canvas">
                    <button type="button" class="btn btn-warning" data-toggle="tooltip" data-placement="top"
                            title="Clear the Canvas" onclick="sendClear()">
                        Clear
                    </button>
                </label>

                <div class="btn-group dropup">
                    <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown"
                            aria-haspopup="true"
                            aria-expanded="false">
                        Room Info
                    </button>
                    <ul class="dropdown-menu">
                        <li><a>Room id: ${curRoom}</a></li>
                        <li><a>Room number: 123</a></li>

                    </ul>
                </div>
            </div>
        </div>
        <div class="input-group col-md-8 preventSelection" style="padding:7px;">
            <input id="messagebox" type="text" class="form-control" placeholder="Send some message here!"/>
                    <span class="input-group-btn">
                        <div onclick="scrollToBottomOfChat()">
                            <button class="btn btn-secondary" type="submit">Send</button>
                        </div>
                    </span>
        </div>
    </div>
</div>
<script type="text/javascript">
    //    prepareCanvas();
</script>

<jsp:include page="../templates/footerTemplate.jsp"/>

</body>
</html>



