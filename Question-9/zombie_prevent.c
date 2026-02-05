#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    int num_children = 5;
    pid_t child_pid;
    
    printf("Parent process started with PID: %d\n", getpid());
    printf("Will create %d child processes.\n\n", num_children);
    
    // Create child processes
    for (int i = 0; i < num_children; i++) {
        child_pid = fork();
        
        if (child_pid < 0) {
            // Fork failed
            perror("fork");
            exit(1);
        } 
        else if (child_pid == 0) {
            // Child process code
            printf("Child %d created with PID: %d\n", i+1, getpid());
            
            // Each child sleeps for different durations (1-3 seconds)
            sleep(i + 1);
            
            printf("Child %d (PID: %d) exiting\n", i+1, getpid());
            exit(0);  // Child exits
        }
        // Parent continues loop to create more children
    }
    
    // Parent process - prevent zombies by waiting for all children
    printf("\nParent process waiting to clean up children...\n");
    
    for (int i = 0; i < num_children; i++) {
        int status;
        pid_t finished_pid = wait(&status);  // Wait for any child to finish
        
        if (finished_pid == -1) {
            perror("wait");
        } else {
            if (WIFEXITED(status)) {
                printf("Parent: Cleaned up child PID %d (exit status: %d)\n", 
                       finished_pid, WEXITSTATUS(status));
            } else if (WIFSIGNALED(status)) {
                printf("Parent: Child PID %d terminated by signal %d\n", 
                       finished_pid, WTERMSIG(status));
            }
        }
    }
    
    printf("\nAll children cleaned up. No zombie processes remain.\n");
    printf("Parent process exiting.\n");
    
    return 0;
}
