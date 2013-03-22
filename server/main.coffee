# use inline javascript here (and at the end of the file)
# to avoid indenting whole module/file
`define(function(require) {`

# we return `app` here so we can start the server in main.js
return require("zappajs").app ->
	swig = require "swig"
	cons = require "consolidate"

	swig.init cache:false
	@use 'zappa'
	@use 'static'

	@app.engine "html", cons.swig
	@app.set("views", "./server/templates")

	@.get "/img", (req, res) ->
		images = fs.readdirSync("./img")
		console.log images
		img = fs.readFileSync("./img/" + images[Math.floor(Math.random() * images.length)])
		res.send img
	@.get "/", (req, res) ->
		res.render("index.html", title:"nerdchatlol")
	@on 'set nickname': ->
		@client.nickname = @data.nickname
  
	@on said: ->
		@broadcast said: {nickname: @client.nickname, text: @data.text}
		@emit said: {nickname: @client.nickname, text: @data.text}

	@client '/index.js': ->
		@connect()

		@on said: ->
			$('#panel').append "<p><b>#{@data.nickname} said:</b> #{@data.text}</p>"
		
		$ =>
			nickname = prompt 'nerds need nicknames...'
			$("label").html("<b>#{nickname}</b>")
			@emit 'set nickname': {nickname: nickname}

			$('#box').focus()

			$('form').submit (e) =>
				@emit said: {text: $('#box').val()}
				$('#box').val('').focus()
				ts = new Date().getTime()
				$("img").prop("src", "/img?#{ts}")
				e.preventDefault()



# use inline javascript here (and at the start of the file)
# to avoid indenting whole module/file
`});`
