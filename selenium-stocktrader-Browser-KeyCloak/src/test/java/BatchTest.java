import org.junit.Test;
import org.junit.Before;
import org.junit.After;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.TimeoutException;

import java.time.Duration;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

public class BatchTest {
    private static final int NUMBER_OF_INSTANCES = 250;
    private static final int BATCH_SIZE = 5;
    private ExecutorService executor;
    private AtomicInteger successCount = new AtomicInteger(0);
    private AtomicInteger loginFailureCount = new AtomicInteger(0);
    private AtomicInteger createUserFailureCount = new AtomicInteger(0);
    private AtomicInteger buyStockFailureCount = new AtomicInteger(0);
    private AtomicInteger sellStockFailureCount = new AtomicInteger(0);
    private AtomicInteger deleteUserFailureCount = new AtomicInteger(0);
    private AtomicInteger otherFailureCount = new AtomicInteger(0);
    private List<String> failureDetails = Collections.synchronizedList(new ArrayList<>());

    @Before
    public void setUp() {
        executor = Executors.newFixedThreadPool(BATCH_SIZE);
    }

    @After
    public void tearDown() {
        executor.shutdown();
    }

    @Test
    public void testParallelExecution() throws InterruptedException, ExecutionException {
        long startTime = System.currentTimeMillis();
        
        for (int batch = 0; batch < NUMBER_OF_INSTANCES; batch += BATCH_SIZE) {
            List<Future<String>> futures = new ArrayList<>();
            int currentBatchSize = Math.min(BATCH_SIZE, NUMBER_OF_INSTANCES - batch);
            
            System.out.println("Starting batch " + (batch/BATCH_SIZE + 1) + 
                             " with " + currentBatchSize + " instances");
            
            for (int i = 0; i < currentBatchSize; i++) {
                futures.add(executor.submit(new TestTask(
                    "Sel-KC-baW-brX-tY" + (batch + i),
                    loginFailureCount,
                    createUserFailureCount,
                    buyStockFailureCount,
                    sellStockFailureCount,
                    deleteUserFailureCount,
                    otherFailureCount
                )));
            }
            
            for (Future<String> future : futures) {
                String result = future.get();
                if (result.contains("Test completed successfully")) {
                    successCount.incrementAndGet();
                }
                System.out.println(result);
            }
            
            printBatchProgress(batch/BATCH_SIZE + 1);
        }
        
        printFinalSummary(startTime);
    }

    private void printBatchProgress(int batchNumber) {
        System.out.println("\nBatch " + batchNumber + " completed");
        System.out.println("Current progress:");
        System.out.println("Success: " + successCount.get());
        System.out.println("Login Failures: " + loginFailureCount.get());
        System.out.println("Create User Failures: " + createUserFailureCount.get());
        System.out.println("Buy Stock Failures: " + buyStockFailureCount.get());
        System.out.println("Sell Stock Failures: " + sellStockFailureCount.get());
        System.out.println("Delete User Failures: " + deleteUserFailureCount.get());
        System.out.println("Other Failures: " + otherFailureCount.get());
    }

    private void printFinalSummary(long startTime) {
        long totalTime = (System.currentTimeMillis() - startTime) / 1000;
        int totalFailures = loginFailureCount.get() + createUserFailureCount.get() + 
                           buyStockFailureCount.get() + sellStockFailureCount.get() + 
                           deleteUserFailureCount.get() + otherFailureCount.get();

        System.out.println("\n========== Test Execution Summary ==========");
        System.out.println("Total Instances Run: " + NUMBER_OF_INSTANCES);
        System.out.println("Successful Completions: " + successCount.get());
        System.out.println("\nFailure Breakdown:");
        System.out.println("- Login Failures: " + loginFailureCount.get());
        System.out.println("- Create User Failures: " + createUserFailureCount.get());
        System.out.println("- Buy Stock Failures: " + buyStockFailureCount.get());
        System.out.println("- Sell Stock Failures: " + sellStockFailureCount.get());
        System.out.println("- Delete User Failures: " + deleteUserFailureCount.get());
        System.out.println("- Other Failures: " + otherFailureCount.get());
        System.out.println("\nTotal Failures: " + totalFailures);
        System.out.println("Success Rate: " + 
            String.format("%.2f%%", (successCount.get() * 100.0) / NUMBER_OF_INSTANCES));
        System.out.println("Total Execution Time: " + totalTime + " seconds");
    }

    private static class TestTask implements Callable<String> {
        private final String ownerToSelect;
        private final AtomicInteger loginFailureCount;
        private final AtomicInteger createUserFailureCount;
        private final AtomicInteger buyStockFailureCount;
        private final AtomicInteger sellStockFailureCount;
        private final AtomicInteger deleteUserFailureCount;
        private final AtomicInteger otherFailureCount;

        public TestTask(String ownerToSelect, 
                       AtomicInteger loginFailureCount,
                       AtomicInteger createUserFailureCount,
                       AtomicInteger buyStockFailureCount,
                       AtomicInteger sellStockFailureCount,
                       AtomicInteger deleteUserFailureCount,
                       AtomicInteger otherFailureCount) {
            this.ownerToSelect = ownerToSelect;
            this.loginFailureCount = loginFailureCount;
            this.createUserFailureCount = createUserFailureCount;
            this.buyStockFailureCount = buyStockFailureCount;
            this.sellStockFailureCount = sellStockFailureCount;
            this.deleteUserFailureCount = deleteUserFailureCount;
            this.otherFailureCount = otherFailureCount;
        }

        @Override
        public String call() {
            WebDriver driver = null;
            try {
                driver = new FirefoxDriver();
                WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(30));
                
                System.out.println("Opening browser in thread: " + ownerToSelect);

                driver.get("https://134.33.226.137:9443/trader");
                
                driver.manage().window().setSize(new Dimension(1130, 702));
                
                // Debug: Check what page we're actually on
                System.out.println("Current URL: " + driver.getCurrentUrl());
                System.out.println("Page title: " + driver.getTitle());
                
                // Wait a bit for page to load and check if we need to handle different auth scenarios
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
                
                // Check if we're on a KeyCloak login page or basic auth page
                String currentUrl = driver.getCurrentUrl();
                String pageSource = driver.getPageSource();
                
                if (currentUrl.contains("keycloak") || currentUrl.contains("auth") || pageSource.contains("kc-login")) {
                    System.out.println("Detected KeyCloak/OIDC login page");
                    // Handle KeyCloak login
                    wait.until(ExpectedConditions.elementToBeClickable(By.id("username")));
                    driver.findElement(By.id("username")).click();
                    driver.findElement(By.id("username")).sendKeys("stock");
                    driver.findElement(By.id("password")).click();
                    driver.findElement(By.id("password")).sendKeys("trader");
                    driver.findElement(By.id("kc-login")).click();
                } else {
                    System.out.println("Detected basic authentication login page");
                    // Handle basic auth login
                    wait.until(ExpectedConditions.elementToBeClickable(By.name("id")));
                    driver.findElement(By.name("id")).click();
                    driver.findElement(By.name("id")).sendKeys("stock");
                    driver.findElement(By.name("password")).click();
                    driver.findElement(By.name("password")).sendKeys("trader");
                    driver.findElement(By.cssSelector("input[type='submit'][name='submit'][value='Submit']")).click();
                }

                // Wait for login to complete and redirect to summary page
                try {
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector("input[name='action'][value='create']")));
                    System.out.println("Login successful: " + ownerToSelect);
                } catch (Exception e) {
                    loginFailureCount.incrementAndGet();
                    throw new Exception("Login failed: " + e.getMessage());
                }

                String xpathExpression = String.format("//input[@type='radio' and @name='owner' and @value='%s']", ownerToSelect);
                // Create user process
                try {
                    // Navigate to create portfolio page
                    driver.findElement(By.cssSelector("input[name='action'][value='create']")).click();
                    driver.findElement(By.name("submit")).click();
                    
                    // Wait for addPortfolio page to load
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("owner")));
                    driver.findElement(By.name("owner")).sendKeys(ownerToSelect);
                    driver.findElement(By.name("submit")).click();
                    
                    // Wait for redirect back to summary page and for the created user to appear
                    wait.until(ExpectedConditions.elementToBeClickable(By.xpath(xpathExpression)));
                    driver.findElement(By.xpath(xpathExpression)).click();
                    driver.findElement(By.name("submit")).click();
                    System.out.println("User created successfully: " + ownerToSelect);

                    // After user creation, redirect to summary page
                    driver.get("https://134.33.226.137:9443/trader/summary");
                    wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("input[name='action'][value='update']")));
                } catch (Exception e) {
                    createUserFailureCount.incrementAndGet();
                    throw new Exception("User creation failed: " + e.getMessage());
                }
                
                // Use only TEST stock as other stocks don't work
                Random random = new Random();
                String randomSymbol = "TEST";
                int randomShares = random.nextInt(50) + 1;

                // Buy stock process
                try {
                    // Debug: Check current page state
                    System.out.println("After user creation - Current URL: " + driver.getCurrentUrl());
                    System.out.println("After user creation - Page title: " + driver.getTitle());
                    
                    // Wait for summary page to be fully loaded
                    wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("input[name='action'][value='update']")));
                    System.out.println("Found update action button, proceeding with buy stock");
                    
                    // Navigate to addStock page for buying
                    driver.findElement(By.cssSelector("input[name='action'][value='update']")).click();
                    driver.findElement(By.name("submit")).click();
                    
                    // Wait for addStock page to load
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("symbol")));
                    System.out.println("AddStock page loaded successfully");
                    
                    int TIME = 3 + random.nextInt(10);  // Random time between 3 and 13 seconds
                    System.out.println("Thinking for " + TIME + " seconds...");
                    TimeUnit.SECONDS.sleep(TIME);
                    driver.findElement(By.name("symbol")).sendKeys(randomSymbol);
                    driver.findElement(By.name("shares")).sendKeys(String.valueOf(randomShares));
                    driver.findElement(By.cssSelector("input[type='submit'][name='submit'][value='Submit']")).click();
                    System.out.println("Stock purchase completed for " + ownerToSelect + ": Bought " + randomShares + " shares of " + randomSymbol);
                } catch (Exception e) {
                    buyStockFailureCount.incrementAndGet();
                    throw new Exception("Stock purchase failed: " + e.getMessage());
                }

                // Sell stock process
                try {
                    // Debug: Check current page state
                    System.out.println("Before sell - Current URL: " + driver.getCurrentUrl());
                    System.out.println("Before sell - Page title: " + driver.getTitle());
                    
                    // Wait for summary page to be fully loaded
                    wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("input[name='action'][value='update']")));
                    System.out.println("Found update action button, proceeding with sell stock");
                    
                    // Navigate to addStock page for selling
                    driver.findElement(By.cssSelector("input[name='action'][value='update']")).click();
                    driver.findElement(By.name("submit")).click();
                    
                    // Wait for addStock page to load
                    wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("symbol")));
                    System.out.println("AddStock page loaded successfully for selling");

                    int TIME = 3 + random.nextInt(10);  // Random time between 3 and 13 seconds
                    System.out.println("Thinking for " + TIME + " seconds...");
                    TimeUnit.SECONDS.sleep(TIME);
                    driver.findElement(By.name("symbol")).sendKeys(randomSymbol);
                    driver.findElement(By.name("shares")).sendKeys(String.valueOf(randomShares));
                    // Select Sell radio button
                    driver.findElement(By.cssSelector("input[name='action'][value='Sell']")).click();
                    driver.findElement(By.cssSelector("input[type='submit'][name='submit'][value='Submit']")).click();
                    System.out.println("Stock sold completed: Sold " + randomShares + " shares of " + randomSymbol + " for " + ownerToSelect);

                    try {
                        WebElement okButton = wait.until(ExpectedConditions.presenceOfElementLocated(
                            By.cssSelector("input[type='submit'][name='submit'][value='OK']")));
                        if (okButton.isDisplayed() && okButton.isEnabled()) {
                            okButton.click();
                            System.out.println("Clicked OK after selling stock.");
                        }
                    } catch (TimeoutException te) {
                        System.out.println("No OK button after selling stock, proceeding.");
                    }
                } catch (Exception e) {
                    sellStockFailureCount.incrementAndGet();
                    throw new Exception("Stock sale failed: " + e.getMessage());
                }

                // Delete user process
                try {
                    wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("input[name='action'][value='delete']")));
                    driver.findElement(By.cssSelector("input[name='action'][value='delete']")).click();
                    driver.findElement(By.xpath(xpathExpression)).click();
                    driver.findElement(By.name("submit")).click();
                    System.out.println("User deleted successfully: " + ownerToSelect);
                } catch (Exception e) {
                    deleteUserFailureCount.incrementAndGet();
                    throw new Exception("User deletion failed: " + e.getMessage());
                }

                return "Test completed successfully for owner: " + ownerToSelect;
            } catch (Exception e) {
                String errorMessage = "Test failed for owner: " + ownerToSelect + ". Error: " + e.getMessage();
                if (!e.getMessage().contains("failed:")) {
                    otherFailureCount.incrementAndGet();
                }
                System.out.println(errorMessage);
                return errorMessage;
            } finally {
                if (driver != null) {
                    driver.quit();
                }
            }
        }
    }
}