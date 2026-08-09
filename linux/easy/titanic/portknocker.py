#!/usr/bin/env python3

###############################################################################
# HTB Titanic SSH Bypass Toolkit
# Port knocking, tunneling, credential testing, and service enumeration
###############################################################################

import socket
import sys
import time
import subprocess
import threading
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime

# Colors
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
CYAN = '\033[0;36m'
NC = '\033[0m'

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def print_banner():
    banner = f"""{CYAN}
╔════════════════════════════════════════════════════════════════╗
║         HTB Titanic SSH Bypass Toolkit (Python)                ║
╚════════════════════════════════════════════════════════════════╝
{NC}"""
    print(banner)

def log_info(msg):
    print(f"{BLUE}[*]{NC} {msg}")

def log_success(msg):
    print(f"{GREEN}[+]{NC} {msg}")

def log_error(msg):
    print(f"{RED}[-]{NC} {msg}")

def log_warning(msg):
    print(f"{YELLOW}[!]{NC} {msg}")

# ============================================================================
# SECTION 1: PORT SCANNING
# ============================================================================

class PortScanner:
    def __init__(self, target, timeout=2):
        self.target = target
        self.timeout = timeout
        self.open_ports = []
        
    def check_port(self, port):
        """Check if a port is open"""
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(self.timeout)
            result = sock.connect_ex((self.target, port))
            sock.close()
            
            if result == 0:
                return True, port
            return False, port
        except Exception as e:
            return False, port
    
    def scan_common_ports(self):
        """Scan common SSH ports"""
        log_info("Scanning common SSH ports...")
        
        common_ports = [22, 222, 2222, 22000, 22222, 20000, 20022, 60000, 8022, 9022, 10022]
        
        with ThreadPoolExecutor(max_workers=10) as executor:
            futures = [executor.submit(self.check_port, port) for port in common_ports]
            
            for future in as_completed(futures):
                open_flag, port = future.result()
                if open_flag:
                    self.open_ports.append(port)
                    log_success(f"Port {port} is open")
                    
                    # Try to get banner
                    self.get_banner(port)
    
    def get_banner(self, port):
        """Get service banner from port"""
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(1)
            sock.connect((self.target, port))
            banner = sock.recv(1024).decode('utf-8', errors='ignore').strip()
            sock.close()
            
            if banner:
                print(f"    └─ Banner: {banner[:80]}")
        except:
            pass
    
    def scan_range(self, start, end):
        """Scan a range of ports"""
        log_info(f"Scanning ports {start}-{end}...")
        
        ports = range(start, end + 1)
        
        with ThreadPoolExecutor(max_workers=50) as executor:
            futures = [executor.submit(self.check_port, port) for port in ports]
            
            count = 0
            for future in as_completed(futures):
                open_flag, port = future.result()
                if open_flag:
                    self.open_ports.append(port)
                    log_success(f"Port {port} is open")
                    self.get_banner(port)
                
                count += 1
                if count % 100 == 0:
                    log_info(f"Progress: {count}/{end-start+1} ports checked")

# ============================================================================
# SECTION 2: PORT KNOCKING
# ============================================================================

class PortKnocker:
    def __init__(self, target, timeout=1):
        self.target = target
        self.timeout = timeout
        
    def knock_sequence(self, sequence):
        """Execute a port knocking sequence"""
        log_info(f"Knocking sequence: {sequence}")
        
        for port in sequence:
            try:
                sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                sock.settimeout(self.timeout)
                sock.connect((self.target, port))
                sock.close()
                print(f"    ✓ Knocked port {port}")
            except:
                print(f"    ✗ Port {port} (timeout)")
            
            time.sleep(0.3)
        
        log_info("Waiting 2 seconds for SSH to open...")
        time.sleep(2)
        
        # Check if SSH opened
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(1)
            result = sock.connect_ex((self.target, 22))
            sock.close()
            
            if result == 0:
                log_success("SSH port 22 is now OPEN!")
                return True
            else:
                log_error("SSH port 22 still closed")
                return False
        except:
            log_error("Error checking SSH")
            return False
    
    def try_common_sequences(self):
        """Try common knocking sequences"""
        log_info("Trying common port knocking sequences...")
        
        sequences = [
            [3000, 4000, 5000],           # Titanic common
            [1111, 2222, 3333],           # Standard
            [4444, 5555, 6666],           # Standard
            [9000, 8000, 7000],           # Reverse
            [7000, 8000, 9000],           # Forward
            [22000, 22001, 22002],        # SSH range
            [5000, 6000, 7000],           # Range
            [8000, 8001, 8002],           # HTTP range
        ]
        
        for seq in sequences:
            print()
            if self.knock_sequence(seq):
                return True
        
        log_error("None of the common sequences worked")
        return False

# ============================================================================
# SECTION 3: SSH CONNECTION TESTING
# ============================================================================

class SSHConnector:
    def __init__(self, target):
        self.target = target
    
    def try_ssh(self, port, username="root"):
        """Try SSH connection with no password (public key)"""
        log_info(f"Attempting SSH to {self.target}:{port} as {username}...")
        
        try:
            result = subprocess.run(
                ['ssh', '-v', '-o', 'ConnectTimeout=3', '-o', 'StrictHostKeyChecking=no',
                 '-o', 'UserKnownHostsFile=/dev/null',
                 f'{username}@{self.target}', '-p', str(port)],
                capture_output=True,
                timeout=5,
                text=True
            )
            
            # Check for success indicators
            if "Authentication successful" in result.stdout or result.returncode == 0:
                log_success(f"SSH connection successful!")
                return True
            
            # Show relevant error messages
            if "Permission denied" in result.stderr:
                log_error(f"Authentication failed (public key rejected)")
            elif "Connection refused" in result.stderr:
                log_error(f"Connection refused")
            elif "Connection timed out" in result.stderr:
                log_error(f"Connection timed out")
            else:
                log_error(f"SSH failed: {result.stderr[:100]}")
            
            return False
        except subprocess.TimeoutExpired:
            log_error("SSH connection timed out")
            return False
        except Exception as e:
            log_error(f"Error: {e}")
            return False
    
    def scan_open_ports_ssh(self, ports, username="root"):
        """Try SSH on multiple ports"""
        for port in ports:
            print()
            if self.try_ssh(port, username):
                return True
        
        return False

# ============================================================================
# SECTION 4: SERVICE ENUMERATION
# ============================================================================

class ServiceEnumerator:
    def __init__(self, target):
        self.target = target
    
    def enum_port(self, port):
        """Enumerate a specific port"""
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(2)
            sock.connect((self.target, port))
            
            # Send different probes
            # HTTP
            sock.send(b"GET / HTTP/1.1\r\nHost: localhost\r\n\r\n")
            response = sock.recv(1024).decode('utf-8', errors='ignore')
            sock.close()
            
            if "HTTP" in response:
                log_success(f"Port {port}: HTTP service detected")
                return "HTTP"
            
            # SSH
            if "SSH" in response:
                log_success(f"Port {port}: SSH service detected")
                return "SSH"
        except:
            pass
        
        return None

# ============================================================================
# SECTION 5: AUTOMATED WORKFLOW
# ============================================================================

class TitanicAutoExploit:
    def __init__(self, target):
        self.target = target
        self.open_ports = []
    
    def run_full_scan(self):
        """Run complete scanning workflow"""
        print()
        log_info("Starting full automated scan workflow...")
        print()
        
        # Step 1: Quick port scan
        log_info("Step 1: Scanning common SSH ports...")
        scanner = PortScanner(self.target)
        scanner.scan_common_ports()
        self.open_ports = scanner.open_ports
        
        if self.open_ports:
            log_success(f"Found {len(self.open_ports)} open port(s)")
            
            # Try SSH on found ports
            log_info("Step 2: Attempting SSH connections...")
            connector = SSHConnector(self.target)
            if connector.scan_open_ports_ssh(self.open_ports):
                return True
        
        # Step 2: Port knocking
        log_info("Step 3: Attempting port knocking...")
        knocker = PortKnocker(self.target)
        if knocker.try_common_sequences():
            # Try SSH on port 22
            connector = SSHConnector(self.target)
            if connector.try_ssh(22):
                return True
        
        # Step 3: Full port range scan
        log_warning("Common methods failed. Attempting full port scan...")
        print()
        response = input("Full port scan can take several minutes. Continue? (y/n): ")
        if response.lower() == 'y':
            scanner = PortScanner(self.target)
            scanner.scan_range(1, 65535)
            self.open_ports = scanner.open_ports
            
            if self.open_ports:
                log_info("Attempting SSH on newly found ports...")
                connector = SSHConnector(self.target)
                if connector.scan_open_ports_ssh(self.open_ports):
                    return True
        
        log_error("Exploitation failed. Manual investigation needed.")
        return False

# ============================================================================
# MAIN
# ============================================================================

def main():
    parser = argparse.ArgumentParser(description='HTB Titanic SSH Bypass Toolkit')
    parser.add_argument('target', help='Target IP address')
    parser.add_argument('--mode', choices=['quick', 'knock', 'enum', 'full'], 
                        default='full', help='Scanning mode')
    parser.add_argument('--port', type=int, help='Specific port to test')
    parser.add_argument('--username', default='root', help='SSH username to try')
    parser.add_argument('--ports', help='Port range (e.g., 1000-10000)')
    
    args = parser.parse_args()
    
    print_banner()
    
    try:
        if args.mode == 'quick':
            log_info(f"Quick scan mode on {args.target}")
            scanner = PortScanner(args.target)
            scanner.scan_common_ports()
            
            if scanner.open_ports:
                connector = SSHConnector(args.target)
                connector.scan_open_ports_ssh(scanner.open_ports, args.username)
        
        elif args.mode == 'knock':
            log_info(f"Port knocking mode on {args.target}")
            knocker = PortKnocker(args.target)
            knocker.try_common_sequences()
        
        elif args.mode == 'full':
            log_info(f"Full automated scan on {args.target}")
            exploit = TitanicAutoExploit(args.target)
            exploit.run_full_scan()
        
        elif args.mode == 'enum':
            log_info(f"Service enumeration on {args.target}")
            if args.port:
                enumerator = ServiceEnumerator(args.target)
                enumerator.enum_port(args.port)
            else:
                log_error("Specify --port for enumeration mode")
    
    except KeyboardInterrupt:
        log_warning("Interrupted by user")
        sys.exit(0)
    except Exception as e:
        log_error(f"Error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()
