package main

import "github.com/gofiber/fiber/v2"

func main() {
    app := fiber.New()

    // This route path will match requests to the root route, "/":
    app.Get("/", func(c *fiber.Ctx) error {
        return c.SendString("root")
    })

    // This route path will match requests to "/about":
    app.Get("/about", func(c *fiber.Ctx) error {
        return c.SendString("about")
    })

    // This route path will match requests to "/random.txt":
    app.Get("/random.txt", func(c *fiber.Ctx) error {
        return c.SendString("random.txt")
    })

    app.Listen(":8080")
}

