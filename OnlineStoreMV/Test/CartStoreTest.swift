//
//  CartStoreTest.swift
//  OnlineStoreMVTests
//
//  Created by Pedro Rojas on 07/03/24.
//

import XCTest
import Testing
@testable import OnlineStoreMV

extension Tag {
    @Tag static let price: Self
    @Tag static let product: Self
    @Tag static let quantity: Self
}

// We can have both XCTest and Swift Testing in the same file
// We can migrate gradually haha
let products = [
    Product(
        id: 1,
        title: "test1",
        price: 123.12,
        description: "",
        category: "",
        imageURL: URL(string: "www.apple.com")!
    ),
    Product(
        id: 2,
        title: "test2",
        price: 77.56,
        description: "",
        category: "",
        imageURL: URL(string: "www.apple.com")!
    ),
    Product(
        id: 3,
        title: "test2",
        price: 91.0,
        description: "",
        category: "",
        imageURL: URL(string: "www.apple.com")!
    )
]

let cartItems = [
    CartItem(
        product: products[0],
        quantity: 3
    ),
    CartItem(
        product: products[1],
        quantity: 1
    ),
    CartItem(
        product: products[2],
        quantity: 2
    ),
]

@Suite("Cart Store Tests")
struct CartStoreTest {
    @Test(
        "Get total amount to pay as string",
        .tags(.price)
    )
    func totalAmountString() {
        let cartStore = CartStore(
            cartItems: cartItems,
            apiClient: .testSuccess
        )
        
        //        let expected = "$628.92"
        //        let actual = cartStore.totalPriceString
        
        #expect(cartStore.totalPriceString == "$628.92")
    }
    
    // We can also have a subset of tests
    @Suite(
        "Subtracting Quantity on Cart Items",
        .tags(.quantity)
    )
    struct SubtractingTest {
        @Test
        func quantityFromItemInCart() {
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.removeFromCart(product: products[0])
            cartStore.removeFromCart(product: products[2])
            let quantity = cartStore.cartItems.reduce(0) {
                $0 + $1.quantity
            }
            
            #expect(quantity == 4)
        }
        
        @Test
        func quantityFromItemInCartUntilMakeItZero() {
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.removeFromCart(product: products[0])
            cartStore.removeFromCart(product: products[1])
            cartStore.removeFromCart(product: products[2])
            cartStore.removeFromCart(product: products[2])
            
            let quantity = cartStore.cartItems.reduce(0) {
                $0 + $1.quantity
            }
            
            #expect(quantity == 2)
        }
    }
    
    @Suite("Removing Items from Cart")
    struct RemovingTest {
        @Test(.tags(.product))
        func oneProductFromCart() {
            let product1 = Product(
                id: 1,
                title: "test1",
                price: 123.12,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let cartItems = [
                CartItem(
                    product: product1,
                    quantity: 4
                )
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            
            cartStore.removeAllFromCart(product: product1)
            
            #expect(cartStore.cartItems.isEmpty)
        }
        
        @Test(.tags(.product))
        func allItemsFromCart() {
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.removeAllItems()
            #expect(cartStore.cartItems.isEmpty)
        }
    }
    
    @Suite("Quantity Tests")
    struct QuantityTesting {
        @Test(.tags(.product))
        func productInCart() {
            let cartItems = [
                CartItem(
                    product: products[0],
                    quantity: 4
                )
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            let quantity = cartStore.quantity(for: products[0])
            #expect(quantity == 4)
        }
        
        @Test(.tags(.product))
        func nonExistingProudctInCart() {
            let unknownProduct = Product(
                id: 1000,
                title: "test1",
                price: 123.12,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let cartItems = [
                CartItem(
                    product: products[0],
                    quantity: 4
                )
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            let quantity = cartStore.quantity(for: unknownProduct)
            #expect(quantity == 0)
        }
    }
    
    @Suite("Add Quantity Tests")
    struct AddingTest {
        @Test(.tags(.quantity))
        func quantityFromExistingItemInCart() {
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.addToCart(product: products[0])
            cartStore.addToCart(product: products[2])
            cartStore.addToCart(product: products[2])
            let quantity = cartStore.cartItems.reduce(0) {
                $0 + $1.quantity
            }
            
            #expect(quantity == 9)
        }
        
        @Test(.tags(.quantity))
        func quantityFromNewItemInCart() {
            let cartItems = [
                CartItem(
                    product: products[0],
                    quantity: 3
                )
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.addToCart(product: products[0])
            cartStore.addToCart(product: products[1])
            
            #expect(cartStore.cartItems.count == 2)
        }
    }
    
}
