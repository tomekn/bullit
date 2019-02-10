# Bullit

Bullet journals for those who don't get along with notebooks.

Currently this implements the 'daily spread' concept of a bullet journal.

You can:
  - Add tasks.
  - Mark tasks as complete.
  - Migrate uncompleted tasks from the previous day.

## Installation

```bash
$ gem install bullit
```
## Usage
```bash
$ bullit generate today
```
On first run, this will instantiate a `~/.bullit` directory which will hold the YAML files used to store the daily logs.

Throughout your day, add new tasks by running
```bash
$ bullit tasks add
```

View your tasks with
```bash
$ bullit tasks list
```

and mark your tasks as complete with
```
$ bullit tasks complete <task_number>
```

The next day, run
```bash
$ bullit generate today
```
To migrate uncompleted tasks from the day before. You will be able to flag tasks as complete in the prompt that will come up, which will stop them from being carried over.

The generate command can be run over and over again without side effects, so you can place it in a startup script to run at the start of the day.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bullit.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
