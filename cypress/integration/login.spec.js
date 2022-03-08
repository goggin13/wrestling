// var ROOT = 'http://localhost:3000'
var ROOT = 'http://wrastling-staging.herokuapp.com'

describe('Logging in', () => {
  it('successfully logs in', () => {
    cy.visit(ROOT)
    cy.contains('Log in')
    cy.get('#user_email').type('goggin13@gmail.com')
    cy.get('#user_password').type('password')
    cy.get('.actions > input').click()
    cy.contains('Signed in successfully.')
  })

  it('rejects an invalid login', () => {
    cy.visit(ROOT)
    cy.contains('Log in')
    cy.get('#user_email').type('goggin13@gmail.com')
    cy.get('#user_password').type('not-the-password')
    cy.get('.actions > input').click()
    cy.contains('Invalid Email or password')
  })
})
