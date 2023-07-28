#include <linux/module.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/string.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Lukas Graber");
MODULE_DESCRIPTION("Showcase Kernel Module Development.");

#define MAX_STR_LEN 1000

char my_string[MAX_STR_LEN] = "";

static ssize_t read_proc(struct file *filp, char *buf, size_t count, loff_t *offp)
{
    size_t chars_to_copy = MAX_STR_LEN > count ? count : MAX_STR_LEN;
    copy_to_user(buf, my_string, chars_to_copy);
    return chars_to_copy;
}

static ssize_t write_proc(struct file * filp, const char *buf, size_t count, loff_t *offp)
{
    memset(my_string, 0, MAX_STR_LEN);
    size_t chars_to_copy = count > MAX_STR_LEN ? MAX_STR_LEN : count;
    copy_from_user(my_string, buf, chars_to_copy);
    return chars_to_copy;
}

static struct proc_ops proc_fops={
	.proc_read = read_proc,
    .proc_write = write_proc
};

static int __init hello_init(void)
{
    printk(KERN_INFO "Initializing module.\n");
    proc_create("hello", 0666, NULL, &proc_fops);
    return 0;
}

static void __exit hello_cleanup(void)
{
    printk(KERN_INFO "Cleaning up module.\n");
    remove_proc_entry("hello",NULL);
}

module_init(hello_init);
module_exit(hello_cleanup);
