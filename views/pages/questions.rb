<!DOCTYPE html>
<html lang="en">

<head>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO"
        crossorigin="anonymous">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Questions</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" media="screen" href="<%= url('/main.css')%>" />
    
    <script src="main.js"></script>
</head>

<body>
    
    <div class="row">
        <div class="col-lg-2"></div>
        <div class="col-lg-8"><h1>Questions</h1></div>
        <div class="col-lg-2"></div>
    </div>
    
    <div class="container">
    
        <div class="container">
            <div class="row">
                <div class="col-lg-12"></div>
            </div>
            <div class="row">
                <div class="col-lg-1 empty-side-left">

                </div>
                <div class="col-lg-10 center">

                 <% @posts.each do |post| %>
                 
                    <div class="row question-<%= post.id %>">
                        <div class="col-lg-2">
                             <label for="Qid"><%= post.id %></label>
                             <input type = "hidden" name = "Qid" value =<%= post.id%>>
                        </div>
                        <div class="col-lg-8">


                            <form method = "POST" action="/question/1">
                                <div class="form-group">
                                    <label for="id"></label>
                                    <input type = "hidden" name = "id" value =<%= post.id%>>
                                    <label for="question" class="flaggedQ"><%= post.question%></label> 
                                    <label for="studentanswer"></label>
                                    <textarea name= "studentanswer" class="form-control" id="question-<%= post.id %>-text" rows="3"><% @answers.each do |answer| %><% if(post.id == answer.id) %><%= answer.studentanswer%><% end %><% end %></textarea>
                                    <input type="submit" value="Submit">
                                    
                                </div>
                            </form>
                        </div>
                        <div class="col-lg-1">
                            <button type="button" class="btn btn-light q1flag"><i class="fa fa-flag"> </i></button>
                        </div>
                    </div>

                    <% end %>
                
                        <div class="col-lg-1">
                            
                            <button type="button" class="btn btn-light q1flag"><i class="fa fa-flag"></i></button>
                        </div>
                    </div>

                    <div class="col-lg-3 empty-side-right">

                    </div>

                </div>
            </div>
        </div>


    <nav>
        <div class="row text-center">
            <div class="col-lg-2">
                <a href='/student/login'><button type="button" class="btn btn-primary">Back</button></a>
            </div>
            <div class="col-lg-8">
                <a href='/info'><button type="button" class="btn btn-info">Info</button></a>
            </div>
            <div class="col-lg-2">
                <a href='/question/2'> <button type="button" class="btn btn-primary">Next</button></a>
            </div>
        </div>
    </nav>

</body>

</html>