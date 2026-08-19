document.addEventListener('DOMContentLoaded', () => {
    // Pega o campo de busca e todos os cartões de livros
    const searchInput = document.getElementById('searchInput');
    const cards = document.querySelectorAll('.card');

    // Adiciona o evento que escuta a digitação
    searchInput.addEventListener('input', (event) => {
        // Transforma o que foi digitado em minúsculo para facilitar a busca
        const searchTerm = event.target.value.toLowerCase();

        // Passa por cada cartão de produto
        cards.forEach(card => {
            // Pega o título do livro dentro do h3
            const title = card.querySelector('.product-title').innerText.toLowerCase();

            // Se o título incluir o que foi digitado, mostra o cartão, senão oculta
            if (title.includes(searchTerm)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    });
});