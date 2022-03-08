// var ROOT = 'http://localhost:3000/'
var ROOT = 'http://wrastling-staging.herokuapp.com/'

describe('Tournament betting page', () => {
  it('shows the users balance', () => {
    cy.visit(ROOT + 'tournaments/1/bet?c=cGF0c3F1ZWdsaWFAZ21haWwuY29t')
    cy.contains('Welcome patsqueglia@gmail.com')
    cy.contains('$10,000')
  })
})
