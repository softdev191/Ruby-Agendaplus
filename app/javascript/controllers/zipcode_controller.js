import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  update(event){
		const xhr = new XMLHttpRequest();
    let zipcode = event.target.value
		const url = `https://viacep.com.br/ws/${zipcode}/json/`;

    if (zipcode.length == 8) {
			xhr.open('GET', url);
			xhr.onload = () => {
  			if (xhr.status === 200) {
    			const data = JSON.parse(xhr.responseText);
          
          if (data["erro"] === true) {
            document.getElementById("zipcode_error_message")
                    .textContent += 'Endereço não encontrado, por favor tente novamente'
          } else {
            document.getElementById("zipcode_error_message").textContent = null
            document.getElementById("address_street").value = data["logradouro"]
					  document.getElementById("address_number").value = data["complemento"]
					  document.getElementById("address_neighborhood").value = data["bairro"]
					  document.getElementById("address_city").value = data["localidade"]
					  document.getElementById("address_state").value = data["uf"]
          }		    	
  			} else {
    			console.error('Error:', xhr.statusText);
  			}
			};

			xhr.onerror = () => {
  			console.error('Network error');
			};

			xhr.send();
    }
  }	
}
