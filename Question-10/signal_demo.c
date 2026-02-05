#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

// Global flag to track received signals
volatile sig_atomic_t sigterm_received = 0;
volatile sig_atomic_t sigint_received = 0;

// Signal handler for SIGTERM
void handle_sigterm(int sig) {
    sigterm_received = 1;
    printf("Parent: Received SIGTERM (signal %d)\n", sig);
}

// Signal handler for SIGINT
void handle_sigint(int sig) {
    sigint_received = 1;
    printf("Parent: Received SIGINT (signal %d)\n", sig);
}

int main() {
    pid_t child_sigterm, child_sigint;
    
    printf("Parent process started with PID: %d\n", getpid());
    
    // Set up signal handlers
    struct sigaction sa_term, sa_int;
    
    // Handle SIGTERM
    sa_term.sa_handler = handle_sigterm;
    sigemptyset(&sa_term.sa_mask);
    sa_term.sa_flags = 0;
    sigaction(SIGTERM, &sa_term, NULL);
    
    // Handle SIGINT  
    sa_int.sa_handler = handle_sigint;
    sigemptyset(&sa_int.sa_mask);
    sa_int.sa_flags = 0;
    sigaction(SIGINT, &sa_int, NULL);
    
    printf("Parent: Signal handlers installed. Waiting for signals...\n");
    
    // Create child that sends SIGTERM after 5 seconds
    child_sigterm = fork();
    if (child_sigterm == 0) {
        // Child 1: Send SIGTERM after 5 seconds
        printf("Child 1 (SIGTERM sender) PID: %d\n", getpid());
        sleep(5);
        printf("Child 1: Sending SIGTERM to parent PID: %d\n", getppid());
        kill(getppid(), SIGTERM);
        exit(0);
    }
    
    // Create child that sends SIGINT after 10 seconds
    child_sigint = fork();
    if (child_sigint == 0) {
        // Child 2: Send SIGINT after 10 seconds
        printf("Child 2 (SIGINT sender) PID: %d\n", getpid());
        sleep(10);
        printf("Child 2: Sending SIGINT to parent PID: %d\n", getppid());
        kill(getppid(), SIGINT);
        exit(0);
    }
    
    // Parent runs indefinitely until signals received
    printf("Parent: Running indefinitely...\n");
    while (1) {
        if (sigterm_received && sigint_received) {
            printf("Parent: Both signals received. Exiting gracefully.\n");
            break;
        }
        printf("Parent: Still running...\n");
        sleep(1);
    }
    
    // Clean up child processes
    wait(NULL);  // Wait for first child
    wait(NULL);  // Wait for second child
    
    printf("Parent: Child processes cleaned up.\n");
    printf("Parent: Exiting gracefully.\n");
    
    return 0;
}
