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



@Suite("Cart Store Tests")
struct CartStoreTest {
    @Test(
        "Get total amount to pay as string",
        .tags(.price)
    )
    func totalAmountString() {
        let cartItems = [
            CartItem(
                product: Product(
                    id: 1,
                    title: "test1",
                    price: 123.12,
                    description: "",
                    category: "",
                    imageURL: URL(string: "www.apple.com")!
                ),
                quantity: 3
            ),
            CartItem(
                product: Product(
                    id: 2,
                    title: "test2",
                    price: 77.56,
                    description: "",
                    category: "",
                    imageURL: URL(string: "www.apple.com")!
                ),
                quantity: 1
            ),
            CartItem(
                product: Product(
                    id: 3,
                    title: "test2",
                    price: 91.0,
                    description: "",
                    category: "",
                    imageURL: URL(string: "www.apple.com")!
                ),
                quantity: 2
            ),
        ]
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
            let product1 = Product(
                id: 1,
                title: "test1",
                price: 123.12,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let product2 = Product(
                id: 2,
                title: "test2",
                price: 77.56,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let product3 = Product(
                id: 3,
                title: "test2",
                price: 91.0,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let cartItems = [
                CartItem(
                    product: product1,
                    quantity: 3
                ),
                CartItem(
                    product: product2,
                    quantity: 1
                ),
                CartItem(
                    product: product3,
                    quantity: 2
                ),
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            let expectedQuantity = 4
            
            cartStore.removeFromCart(product: product1)
            cartStore.removeFromCart(product: product3)
            let actualQuantity = cartStore.cartItems.reduce(0) {
                $0 + $1.quantity
            }
            
            XCTAssertEqual(expectedQuantity, actualQuantity)
        }
        
        @Test
        func quantityFromItemInCartUntilMakeItZero() {
            let product1 = Product(
                id: 1,
                title: "test1",
                price: 123.12,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let product2 = Product(
                id: 2,
                title: "test2",
                price: 77.56,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let product3 = Product(
                id: 3,
                title: "test2",
                price: 91.0,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let cartItems = [
                CartItem(
                    product: product1,
                    quantity: 3
                ),
                CartItem(
                    product: product2,
                    quantity: 1
                ),
                CartItem(
                    product: product3,
                    quantity: 2
                ),
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            let expectedQuantity = 2
            
            cartStore.removeFromCart(product: product1)
            cartStore.removeFromCart(product: product2)
            cartStore.removeFromCart(product: product3)
            cartStore.removeFromCart(product: product3)
            
            let actualQuantity = cartStore.cartItems.reduce(0) {
                $0 + $1.quantity
            }
            
            XCTAssertEqual(expectedQuantity, actualQuantity)
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
            
            let expected: [CartItem] = []
            
            cartStore.removeAllFromCart(product: product1)
            
            let actual = cartStore.cartItems
            
            XCTAssertEqual(expected, actual)
        }
        
        @Test(.tags(.product))
        func allItemsFromCart() {
            let product1 = Product(
                id: 1,
                title: "test1",
                price: 123.12,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let product2 = Product(
                id: 2,
                title: "test2",
                price: 77.56,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let product3 = Product(
                id: 3,
                title: "test2",
                price: 91.0,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let cartItems = [
                CartItem(
                    product: product1,
                    quantity: 3
                ),
                CartItem(
                    product: product2,
                    quantity: 1
                ),
                CartItem(
                    product: product3,
                    quantity: 2
                ),
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            let expected: [CartItem] = []
            
            cartStore.removeAllItems()
            
            let actual = cartStore.cartItems
            
            XCTAssertEqual(expected, actual)
        }
    }
    
    @Suite("Quantity Tests")
    struct QuantityTesting {
        @Test(.tags(.product))
        func productInCart() {
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
            
            let expected = 4
            let actual = cartStore.quantity(for: product1)
            
            XCTAssertEqual(expected, actual)
        }
        
        @Test(.tags(.product))
        func nonExistingProudctInCart() {
            let product1 = Product(
                id: 1,
                title: "test1",
                price: 123.12,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
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
                    product: product1,
                    quantity: 4
                )
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            let expected = 0
            let actual = cartStore.quantity(for: unknownProduct)
            
            XCTAssertEqual(expected, actual)
        }
    }
    
    @Suite("Add Quantity Tests")
    struct AddingTest {
        @Test(.tags(.quantity))
        func quantityFromExistingItemInCart() {
            let product1 = Product(
                id: 1,
                title: "test1",
                price: 123.12,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let product2 = Product(
                id: 2,
                title: "test2",
                price: 77.56,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let product3 = Product(
                id: 3,
                title: "test2",
                price: 91.0,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let cartItems = [
                CartItem(
                    product: product1,
                    quantity: 3
                ),
                CartItem(
                    product: product2,
                    quantity: 1
                ),
                CartItem(
                    product: product3,
                    quantity: 2
                ),
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            let expectedQuantity = 9
            
            cartStore.addToCart(product: product1)
            cartStore.addToCart(product: product3)
            cartStore.addToCart(product: product3)
            let actualQuantity = cartStore.cartItems.reduce(0) {
                $0 + $1.quantity
            }
            
            XCTAssertEqual(expectedQuantity, actualQuantity)
        }
        
        @Test(.tags(.quantity))
        func quantityFromNewItemInCart() {
            let product1 = Product(
                id: 1,
                title: "test1",
                price: 123.12,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let product2 = Product(
                id: 2,
                title: "test2",
                price: 77.56,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let cartItems = [
                CartItem(
                    product: product1,
                    quantity: 3
                )
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            let expectedCartItemsCount = 2
            
            cartStore.addToCart(product: product1)
            cartStore.addToCart(product: product2)
            
            let actualCartItemsCount = cartStore.cartItems.count
            
            XCTAssertEqual(expectedCartItemsCount, actualCartItemsCount)
        }
    }
    
}
