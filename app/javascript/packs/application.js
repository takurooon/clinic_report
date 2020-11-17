// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("chartkick")
require("chart.js")
require("./jquery.validationEngine")
require("./jquery.validationEngine-ja")
require("./form_validation")

// import "bootstrap"
import "../stylesheets/application"
import 'bootstrap-material-design'
import "@fortawesome/fontawesome-free/js/all";
import "../stylesheets/application";

// import "cocoon"
import "cocoon";

document.addEventListener("turblinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()
})

const feather = require("feather-icons");
document.addEventListener("turbolinks:load", function() {
    feather.replace();
})

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

require("trix")
require("@rails/actiontext")
// require("jquery-ui.min")
// require("jquery.tagsinput.min.min")
// require("jquery.validationEngine-ja")