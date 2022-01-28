var express = require('express');
var bodyParser = require('body-parser');
const mysql = require('mysql')
var app = express();
const path = require('path');
var cookieParser = require('cookie-parser');
var session = require('express-session');
const uuid = require("uuid");

app.use(bodyParser.urlencoded({ extended: false }))

// parse application/json
app.use(bodyParser.json())
app.set('view engine', 'ejs');

app.use(cookieParser());
app.use(session({secret: "Shh, its a secret!",saveUninitialized:true, resave: false}));


app.use(express.static(path.join(__dirname, '/public')));

const db = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '',
    database : 'retest'
});

db.connect((err)=>{
    if(err) throw err
    console.log("Connected to db")
})

app.get("/",(req,res)=>{
    res.render("index");
});

app.get("/contactinfo",(req,res)=>{
    res.render("contactinfo");
});  

app.all("/signin",(req,res)=>{

    if(req.method=="POST"){
        const params = req.body;
        const sql = `SELECT id, role FROM users WHERE username="${params.username}" AND password="${params.password}"`;

        db.query(sql, (err,results)=>{
            if(err) throw err;
 
            if(results.length==0){
               res.render("login",{error:true})
            }else if(results.length!=0 && results[0].role=="guest"){
                var session = req.session
                session.userid = results[0].id;
                res.redirect("/guestdashboard");
            }
            else if(results.length!=0 && results[0].role=="admin"){
                var session = req.session
                session.userid = results[0].id;
                res.redirect("/admindashboard");
            }
        })

    }else{
        res.render("login",{error:false})
    }
});

app.get("/admindashboard",(req,res)=>{

    if(req.session.userid!=null){
       
        db.query(`
        SELECT tf.transactionid, tf.mop, tf.date, us.fname, us.lname, tf.status, SUM(tf.quantity*pr.pprice) as Total
        FROM transaction as tf
        INNER JOIN users as us ON tf.uid = us.id
        INNER JOIN products as pr ON tf.pid = pr.id
        GROUP BY tf.transactionid
        `, (err, rows) => {
            if (!err) {
                console.log(rows);
                console.log(rows[0].fname);
                res.render('admin',{data:rows});
            } 
        })

    }else{
        res.redirect("/signin");
    }

});

app.all("/signup", (req,res)=>{
    if (req.method == "POST"){
        var params = req.body;
        params.role = "guest";
        console.log(params)
        db.query("INSERT INTO users SET ?",params, (err, result)=>{
            if(err) throw err;
            
            db.query("SELECT LAST_INSERT_ID() as id",(err1, result1)=>{
                if(err1) throw err1;
                
                var session = req.session;
                session.userid = result1[0].id;

                res.redirect("/guestdashboard")

            })

    })
    }
    else{
        res.render("signup")
    }
 });

    app.get("/logout", (req,res)=>{
        req.session.destroy();
        res.redirect("/");
    });


 app.get("/guestdashboard",(req,res)=>{

    if(req.session.userid!=null){
        db.query("SELECT * FROM users WHERE id = "+req.session.userid,(err, results)=>{
            if(err) throw err;

            db.query("SELECT status	FROM applicationform WHERE userid="+req.session.userid,(err1, results1)=>{
                if(err1) throw err1;

                results1.length >0 ?
                res.render("guestdashboard",{data:results[0],status:results1[0].status}):
                res.render("guestdashboard",{data:results[0],status:null});
            })

        });

    }else{
        res.redirect("/login");
    }

});

 app.post("/update", (req,res)=>{
        const params = req.body;
    
        const sql = `UPDATE users SET username="${params.upusername}",password="${params.uppassword}",fname="${params.upfname}",lname="${params.uplname}",contactno=${params.upcontactno}, email="${params.upemailadd}" WHERE id = ${params.upid}`;
    
        db.query(sql,(err,result)=>{
            if (err) throw err
            res.send(true);
    
        });
    
    });

app.get("/orderform",(req,res)=>{
        if(req.session.userid!=null){
            db.query(`SELECT * FROM users WHERE id = ${req.session.userid}`, (err, rows) => {
                if(err) throw err;
                
                db.query(`SELECT * FROM products `, (err1, rows1) => {

                    res.render("orderform",{data:rows,products:rows1})
                    
                })
                
            })
        }else{  
            res.redirect("/");
        }
    });

    app.get("/submitorderform",(req,res)=>{
        if(req.session.userid!=null){
            db.query(`SELECT * FROM users WHERE id = ${req.session.userid}`, (err, rows) => {
                if(err) throw err;
                res.render("orderform",{data:rows})
            })
        }else{  
            res.redirect("/");
        }
    });


    app.post("/insertapplicationform",(req,res)=>{

        const params = req.body;
        const sql  = "INSERT INTO applicationform SET ?"
    
        db.query(sql, params,(err, result)=>{
            if(err) throw err;
            res.redirect("/guestdashboard")
        });
    
    });
    app.get("/vieworder/:id",(req,res)=>{

        const id = req.params.id;

        console.log(id)
        db.query(`
        SELECT pr.pname, tf.quantity, (tf.quantity*pr.pprice) as Total
        FROM transaction as tf
        INNER JOIN products as pr ON tf.pid = pr.id
        WHERE tf.transactionid = "${id}"
        `,(err,results)=>{
            if(err) throw err;
            res.render("vieworder",{data:results})
        });
    });

    app.post("/approveapplication",(req,res)=>{
        const params=req.body;
        db.query(`UPDATE transaction SET status = 'delivered' WHERE transactionid = '${params.upid}'`,(err)=>{
            if(err) throw err
            res.send(true);
        })
    });

    app.post("/declineapplication",(req,res)=>{
        const params=req.body;
        db.query("UPDATE applicationform SET status = 'declined' WHERE id = "+params.upid,(err)=>{
            if(err) throw err
            res.send(true);
        })
    });


    app.post("/addorder",(req,res)=>{
  
        const params =JSON.parse(req.body.data);
        const transaction_id = uuid.v4();


        for(var i = 0; i<params.selected.length;i++){
            db.query(`INSERT INTO transaction (uid,pid,quantity,transactionid,date,mop) VALUES (${req.session.userid},${params.selected[i].id},${params.selected[i].quantity},"${transaction_id}","${params.others.date_ordered}","${params.others.mode}")`,(err)=>{
                if(err) throw err;
                console.log(i);
            })
        }
        res.send(true)
            
    });


app.listen(process.env.PORT||3000);
