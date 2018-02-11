require 'rails_helper'

RSpec.describe "adding to cart" do
  let(:buyer) { User.create(email: "buyer@example.com", password: "password") }
  let(:play) { Event.create(name: "A Midsummer Night's Dream") }
  let(:first_performance) { play.performances.create(
    start_time: "2018-02-08 19:00:00") }
  let(:next_performance) { play.performances.create(
    start_time: "2018-02-09 19:00:00") }
  
  def create_tickets_for(performance)
    2.times do
      Ticket.create(performance: performance,
                    status: "unsold",
                    price_cents: 1500)
    end
  end
  
  before do
    sign_in(buyer.email, buyer.password)
    create_tickets_for(first_performance)
    create_tickets_for(next_performance)
  end
  
  it "adds tickets to a cart" do
    visit event_path(play)
    within("#performance_#{first_performance.id}") do
      select("2", from: "ticket_count")
      click_on("add-to-cart")
    end
    
    expect(current_url).to match("cart")
    within("#event_#{play.id}") do
      within("#performance_#{first_performance.id}") do
        expect(page).to have_selector(".ticket_count", text: "2")
        expect(page).to have_selector(".subtotal", text: "$30")
      end
      expect(page).not_to have_selector("#performance_#{next_performance.id}")
    end
  end
end